(require (lib "69.ss" "srfi"))

;; Helpers

(define (last list)
  (if (or (null? list) (null? (cdr list)))
      list
      (last (cdr list))))

(define-syntax push!
  (syntax-rules ()
    ((push! <value> <place>)
     (set! <place> (cons <value> <place>)))))

(define (fold f z list)
  (if (null? list)
      z
      (f (car list) (fold f z (cdr list)))))

(define (all? predicate . lists)
  (call-with-current-continuation
   (lambda (exit)
     (if (apply predicate (map (lambda (list) (if (null? list) (exit #t) (car list))) lists))
         (apply all? predicate (map cdr lists))
         #f))))

(define (assoc-push-back! alist key value)
  ;; Usage: (set! as (assoc-push-back as k v))
  (let ((existing (assoc key alist)))
    (cond (existing (set-cdr! (last existing) (cons value '()))
                    alist)
          (else (cons (cons key (list value)) alist)))))

(define (node-freshener assoc make-fresh)
  (let ((symms '()))
    (lambda (elt)
      (cond ((assoc elt symms) => cdr)
            (else (let ((symm (make-fresh)))
                    (push! (cons elt symm) symms)
                    symm))))))



;; Abstract term syntax and s-exp conversion/copying

(define (make-variable) (unbind! (make-vector 1)))
(define (variable? term) (vector? term))
(define (unbind! variable) (vector-set! variable 0 variable) variable)
(define (bind! variable value) (vector-set! (dereference variable) 0 value) variable)
(define (bound? term)
  (if (variable? term)
      (let ((value (vector-ref term 0)))
        (if (eq? term value)
            #f
            (bound? value)))
      #t))
(define (dereference term)
  (if (variable? term)
      (let ((value (vector-ref term 0)))
        (if (eq? term value)
            term
            (dereference value)))
      term))

(define (make-compound name parameters) `(,name ,(length parameters) . ,parameters))
(define (compound? term) (pair? term))
(define (compound-name compound) (car compound))
(define (compound-arity compound) (cadr compound))
(define (compound-parameters compound) (cddr compound))
(define (compound-functor compound)
  (functor (compound-name compound) (compound-arity compound)))
(define (functor name arity)
  (string->symbol (string-append (symbol->string name) "/" (number->string arity))))
(define (equal-functors? compound-1 compound-2)
  (and (equal? (compound-name  compound-1) (compound-name  compound-2))
       (=      (compound-arity compound-1) (compound-arity compound-2))))
(define (numeric-value? term)
  (and (compound? term) (= 1 (compound-arity term)) (number? (car (compound-parameters term)))
       (car (compound-parameters term))))

(define (equal-terms? term-1 term-2)
  (let ((value-1 (dereference term-1)) (value-2 (dereference term-2)))
    (cond ((and (variable? value-1) (variable? value-2)) (eq? value-1 value-2))
          ((and (compound? value-1) (compound? value-2))
           (and (equal-functors? value-1 value-2)
                (all? equal-terms? (compound-parameters value-1)
                                   (compound-parameters value-2))))
          (else #f))))

(define (make-term-thawer)
  (letrec ((gensym (node-freshener assoc make-variable))
           (term-thawer
            (lambda (term)
              (cond ((equal? term '_) (make-variable))
                    ((equal? term '!) (make-compound '! '()))
                    ((symbol? term)   (gensym term))
                    ((number? term)   (make-compound term '()))
                    ((pair? term)     (make-compound (car term)
                                                     (map term-thawer (cdr term))))))))
    term-thawer))

(define (make-term-freezer)
  (letrec ((gensym (node-freshener assq
                    (let ((counter 0))
                      (lambda ()
                        (set! counter (+ 1 counter))
                        (string-append "<" (number->string counter) ">")))))
           (term-freezer
            (lambda (term)
              (let ((term (dereference term)))
                (cond ((variable? term) (gensym term))
                      ((numeric-value? term) (compound-name term))
                      ((equal-terms? term (make-compound '! '())) '!)
                      ((compound? term)
                       (cons (compound-name term) (map term-freezer
                                                       (compound-parameters term)))))))))
    term-freezer))

(define (make-term-copyer)
  (letrec ((gensym (node-freshener assq make-variable))
           (term-copyer
            (lambda (term)
              (let ((term (dereference term)))
                (if (variable? term)
                    (gensym term)
                    (make-compound (compound-name term) (map term-copyer
                                                             (compound-parameters term))))))))
    term-copyer))



;; The unifier, takes lists of equations of terms
;; binds variables and returns a unifier or binds nothing and returns #f

(define equate cons)
(define equation-lhs car)
(define equation-rhs cdr)

(define (occurs? variable term)
  (let ((term (dereference term)))
    (if (bound? term)
        (let loop ((parameters (compound-parameters term)))
          (cond ((null? parameters) #f)
                ((occurs? variable (car parameters)) #t)
                (else (loop (cdr parameters)))))
        (eq? variable term))))

(define (unify equations)
  ;; Returns a list of bound variables, lhs are variables that have been set!
  ;; is it best to do eager binding and unbinding
  ;; or map bind only after finding the mgu
  (define (add-binding lhs rhs rest) ;; maybe TCO this
    (cond (rest (vector-set! lhs 0 rhs)
                (cons lhs rest))
          (else #f)))
  (if (null? equations)
      '()
      (let ((lhs (dereference (equation-lhs (car equations))))
            (rhs (dereference (equation-rhs (car equations)))))
        (cond ((eq? lhs rhs) (unify (cdr equations)))
              ((and (compound? lhs) (compound? rhs))
               (if (equal-functors? lhs rhs)
                   (unify (append (map equate ;; NOTE can you improve this by removing append?
                                       (compound-parameters lhs)
                                       (compound-parameters rhs))
                                  (cdr equations)))
                   #f))
              ((not (variable? lhs)) (unify (cons (equate rhs lhs) (cdr equations)))) ;;!
              ((occurs? lhs rhs) #f)
              (else (add-binding lhs rhs (unify (cdr equations))))))))



;; Working with a database, clause compiling and lookup

(define make-clause cons)
(define (clause-head clause-printer) (car clause-printer))
(define (clause-body clause-printer) ((cdr clause-printer)))

(define (compile-declaration declaration)
  (define (fold-body terms) ;; turning a list of terms into a conjuction
    (cond ((null? terms) (make-compound 'true '()))
          ((null? (cdr terms)) (car terms))
          (else (fold (lambda (before after)
                        (make-compound 'and (list before after)))
                      (car (last terms))
                      (reverse (cdr (reverse terms)))))))
  (list (car (cadr declaration))
        (length (cdr (cadr declaration)))
        (lambda ()
          (let ((term-converter (make-term-thawer)))
            (make-clause (make-compound (car (cadr declaration))
                                        (map term-converter (cdr (cadr declaration))))
                         (lambda () (fold-body (map term-converter (cddr declaration)))))))))

(define (make-database) (make-hash-table))
(define (add-declaration base compiled-declaration)
  (hash-table-update!/default base
   (car compiled-declaration)
   (lambda (entry)
     (assoc-push-back! entry (cadr compiled-declaration) (caddr compiled-declaration)))
   '()))

(define (lookup base compound)
  (let ((name (compound-name compound))
        (arity (compound-arity compound)))
    (let ((clauses (assoc arity (hash-table-ref/default base name '()))))
      (if clauses (cdr clauses) '()))))

(define (consult file)
  (let ((base (make-database)))
    (call-with-input-file file
      (lambda (port)
        (let loop ((object (read port)))
          (if (eof-object? object)
              base
              (begin (add-declaration base (compile-declaration object))
                     (loop (read port)))))))))


;; Choicepoints

