;; Prolog interpreter - version 0.5

;; For mzscheme:
;; (require (lib "69.ss" "srfi"))

;; For SISC:
;; (require-library 'sisc/libs/srfi/srfi-69)
;; (import srfi-69)

;; For Chicken:
;; csc prolog.scm -require-extension syntactic-closures

;; For mit-scheme:
;; ;; works as is

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-variable) (unbind! (make-vector 1)))
(define (dereference variable)
  (if (variable? variable)
      (let ((value (vector-ref variable 0)))
        (if (eq? variable value)
            value
            (dereference value)))
      variable))
(define (bind! variable value) (vector-set! (dereference variable) 0 value) variable)
(define (unbind! variable) (vector-set! variable 0 variable) variable)
(define (variable? term) (vector? term))
(define (variable-unbound? variable) (eq? variable (dereference variable)))
(define (variable-bound? variable) (not (variable-unbound? variable)))
(define (unbound-variable? term) (and (variable? term) (variable-unbound? term)))
(define (equal-variables? var-1 var-2) (eq? (dereference var-1) (dereference var-2)))

(define (make-compound name parameters) `(,name ,(length parameters) . ,parameters))
(define (compound? term) (pair? term))
(define (compound-name compound) (car compound))
(define (compound-arity compound) (cadr compound))
(define (compound-parameters compound) (cddr compound))
(define (functor name arity)
  (string->symbol (string-append (symbol->string name) "/" (number->string arity))))
(define (compound-functor compound)
  (functor (compound-name compound) (compound-arity compound)))

(define equate cons)
(define equation-lhs car)
(define equation-rhs cdr)

(define (enable-bindings! bindings)
  (map (lambda (binding) (if (variable-unbound? (car binding))
                             (bind! (car binding) (cdr binding))
                             (void)))
       bindings))

(define (disable-bindings! bindings)
  (map (lambda (binding) (unbind! (car binding))) bindings))

(define-syntax within
  (syntax-rules ()
    ((within <bindings> <body> ...)
     (dynamic-wind
         (lambda () (enable-bindings! <bindings>))
         (lambda () <body> ...)
         (lambda () (disable-bindings! <bindings>))))))

(define (numeric-value? term)
  (let ((term (dereference term)))
    (if (and (compound? term) (number? (compound-name term)))
        (compound-name term)
        #f)))

(define (equal-terms? term-1 term-2)
  (let ((value-1 (dereference term-1)) (value-2 (dereference term-2)))
    (cond ((and (variable? value-1) (variable? value-2)) (eq? value-1 value-2))
          ((and (compound? value-1) (compound? value-2))
           (and (equal? (compound-name  value-1) (compound-name  value-2))
                (=      (compound-arity value-1) (compound-arity value-2))
                (all? equal-terms? (compound-parameters value-1)
                                   (compound-parameters value-2))))
          (else #f))))

(define (make-term-converter)
  (letrec ((gensym (node-freshener assoc make-variable))
           (term-converter
            (lambda (term)
              (cond ((equal? term '_) (make-variable))
                    ((equal? term '!) (make-compound '! '()))
                    ((symbol? term)   (gensym term))
                    ((number? term)   (make-compound term '()))
                    ((pair? term)     (make-compound (car term)
                                                     (map term-converter (cdr term))))))))
    term-converter))

(define (term-freezer)
  (letrec ((gensym (node-freshener assq
                    (let ((counter 0))
                      (lambda ()
                        (set! counter (+ 1 counter))
                        (string-append "<" (number->string counter) ">")))))
           (freeze-term
            (lambda (term)
              (cond ((unbound-variable? term) (gensym term))
                    ((variable? term) (freeze-term (dereference term)))
                    ((numeric-value? term) (compound-name term))
                    ((equal-terms? term (make-compound '! '())) '!)
                    ((compound? term)
                     (cons (compound-name term) (map freeze-term
                                                     (compound-parameters term))))))))
    freeze-term))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (occurs? unbound-variable term)
  (cond ((unbound-variable? term)
                          (equal-variables? unbound-variable term))
        ((variable? term) (occurs? unbound-variable (dereference term)))
        ((compound? term) (let loop ((parameters (compound-parameters term)))
                            (and (not (null? parameters))
                                 (or (occurs? unbound-variable (car parameters))
                                     (loop (cdr parameters))))))))

(define (unify equations)
  (define (cons/fail car cdr) (if cdr (cons car cdr) cdr))
  (if (null? equations)
      '()
      (let ((lhs (dereference (equation-lhs (car equations))))
            (rhs (dereference (equation-rhs (car equations)))))
        (cond ((equal-terms? lhs rhs) (unify (cdr equations)))
              ((and (compound? lhs) (compound? rhs))
               (if (and (equal? (compound-name lhs) (compound-name rhs))
                        (= (compound-arity lhs) (compound-arity rhs)))
                   (unify (append (map equate
                                       (compound-parameters lhs)
                                       (compound-parameters rhs))
                                  (cdr equations)))
                   #f))
              ((not (variable? lhs)) (unify (cons (equate rhs lhs) (cdr equations))))
              ((occurs? lhs rhs) #f)
              (else (within (list (equate lhs rhs))
                            (cons/fail (equate lhs rhs) (unify (cdr equations)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
          (let ((term-converter (make-term-converter)))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define empty-stream #f)
(define cut-empty-stream #t)
(define empty-stream? boolean?)

(define (stream-cons* head tail) (cons (cons head #f) tail))
(define-syntax stream-cons
  (syntax-rules ()
    ((stream-cons head tail)
     (stream-cons* head (lambda () tail)))))

(define (stream-cutting-cons* head tail) (cons (cons head #t) tail))
(define-syntax stream-cutting-cons
  (syntax-rules ()
    ((stream-cutting-cons head tail)
     (stream-cutting-cons* head (lambda () tail)))))

(define (stream-head stream) (caar stream))
(define (stream-tail stream) ((cdr stream)))
(define (cut? stream) (if (empty-stream? stream) stream (cdar stream)))
(define (cut! stream) (if (empty-stream? stream)
                          cut-empty-stream
                          (stream-cutting-cons* (stream-head stream) (cdr stream))))
(define (add-cut-if! cut? stream) (if cut? (cut! stream) stream))

(define (stream-map f stream)
  (if (empty-stream? stream)
      stream
      (cons (cons (f (stream-head stream)) (cut? stream))
            (lambda () (stream-map f (stream-tail stream))))))

(define (stream-append front back)
  (if (cut? front)
      front
      (if (empty-stream? front)
          back
          (stream-cons (stream-head front)
                       (stream-append (stream-tail front) back)))))

(define (stream-append* front back)
  (if (cut? front)
      front
      (if (empty-stream? front)
          (back)
          (stream-cons (stream-head front)
                       (stream-append* (stream-tail front) back)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define failure empty-stream)
(define (success bindings) (stream-cons bindings empty-stream))
(define (lift-boolean bindings boolean) (if boolean (success bindings) failure))

(define (disjunction heads tails)
  (stream-append* heads tails))
(define (conjunction heads tails)
  (if (empty-stream? heads)
      failure
      (disjunction (add-cut-if! (cut? heads) (tails (stream-head heads)))
                   (lambda ()
                     (conjunction (stream-tail heads) tails)))))

(define (perform-unification lhs rhs bindings)
  (within bindings (let ((result (unify (list (equate lhs rhs)))))
                     (if result (success result) failure))))

(define (prove base bindings query)
  (cond
   ((unbound-variable? query)
    (within bindings (if (unbound-variable? query)
                         (error "Unbound variable")
                         (prove base bindings (dereference query)))))
   
   ((primitive? (compound-functor query))
    => (lambda (primitive) (execute-primitive primitive base bindings query)))
     
   ((equal? 'true/0 (compound-functor query))
    (success bindings))
     
   ((equal? '!/0 (compound-functor query))
    (cut! (success bindings)))
   
   ((equal? 'and/2 (compound-functor query))
    (conjunction (prove base bindings (car (compound-parameters query)))
                 (lambda (more)
                   (prove base (append bindings more) (cadr (compound-parameters query))))))
   
   (else
    (let clause-loop ((clauses (lookup base query)))
      (if (null? clauses)
          failure
          (let ((clause ((car clauses))))
            (disjunction
             (conjunction (perform-unification query (clause-head clause) bindings)
                          (lambda (more)
                            (prove base (append bindings more) (clause-body clause))))
             (lambda () (clause-loop (cdr clauses))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define +primitives+ '())
(define (primitive? functor) (assoc functor +primitives+))
(define (execute-primitive primitive base bindings query)
  (within bindings (apply (cdr primitive) base bindings (compound-parameters query))))
(define (define-primitive* name arity procedure)
  (push! (cons (functor name arity) procedure) +primitives+))
(define-syntax define-primitive
  (syntax-rules ()
    ((define-primitive <base> <bindings> (<name> <parameters> ...)
       <body> ...)
     (define-primitive* '<name> (length '(<parameters> ...))
       (lambda (<base> <bindings> <parameters> ...)
         <body> ...)))))
(define-syntax define-boolean-operation-primitive
  (syntax-rules ()
    ((define-boolean-operation-primitive (<name> <parameters> ...) <body> ...)
     (define-primitive _ bindings (<name> <parameters> ...)
       (lift-boolean bindings (and <body> ...))))))
(define-syntax define-numeric-comparison-operator-primitive
  (syntax-rules ()
    ((define-numeric-comparison-operator-primitive <name> <function>)
     (define-boolean-operation-primitive (<name> x y)
       (numeric-value? x)
       (numeric-value? y)
       (<function> (numeric-value? x) (numeric-value? y))))))
(define-syntax define-numeric-binary-op-primitive
  (syntax-rules ()
    ((define-numeric-binary-op-primitive <name> <function>)
     (define-primitive _ bindings (<name> x y r)
       (let ((x (numeric-value? x))
             (y (numeric-value? y)))
         (if (and x y)
             (let ((result (unify (list (equate r (make-compound (<function> x y) '()))))))
               (if result (success (append result bindings)) failure))
             failure))))))
(define-syntax define-numeric-unary-op-primitive
  (syntax-rules ()
    ((define-numeric-unary-op-primitive <name> <function>)
     (define-primitive _ bindings (<name> x r)
       (let ((x (numeric-value? x)))
         (if x
             (let ((result (unify (list (equate r (make-compound (<function> x) '()))))))
               (if result (success (append result bindings)) failure))
             failure))))))

(define-boolean-operation-primitive (variable? term) (unbound-variable? term))
(define-boolean-operation-primitive (not-variable? term) (not (unbound-variable? term)))
(define-boolean-operation-primitive (atomic? term) (compound? term) (= 0 (compound-arity term)))
(define-boolean-operation-primitive (compound? term) (compound? term) (> 0 (compound-arity term)))
(define-boolean-operation-primitive (number? term) (numeric-value? term))

(define-numeric-comparison-operator-primitive <  <)
(define-numeric-comparison-operator-primitive =< <=)
(define-numeric-comparison-operator-primitive >  >)
(define-numeric-comparison-operator-primitive >= >=)

(define-numeric-binary-op-primitive %+   +)
(define-numeric-binary-op-primitive %-   -)
(define-numeric-binary-op-primitive %*   *)
(define-numeric-binary-op-primitive %/   /)
(define-numeric-binary-op-primitive %**  expt)
(define-numeric-binary-op-primitive %mod modulo)
(define-numeric-binary-op-primitive %rem remainder)

(define-numeric-unary-op-primitive %sqrt    sqrt)
(define-numeric-unary-op-primitive %sin     sin)
(define-numeric-unary-op-primitive %cos     cos)
(define-numeric-unary-op-primitive %tan     tan)
(define-numeric-unary-op-primitive %asin    asin)
(define-numeric-unary-op-primitive %acos    acos)
(define-numeric-unary-op-primitive %atan    atan)
(define-numeric-unary-op-primitive %abs     abs)
(define-numeric-unary-op-primitive %floor   floor)
(define-numeric-unary-op-primitive %round   round)
(define-numeric-unary-op-primitive %ceiling ceiling)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Horrid little thing to test queries
;; (TODO: make a nice REPL)

(define (interact base query)
  (let ((query ((make-term-converter) query)))
    (let loop ((result (prove base '() query)))
      (if (empty-stream? result)
          'no
          (begin (map (lambda (pair)
                        (if (unbound-variable? (car pair))
                            (bind! (car pair) (cdr pair))
                            (void)))
                      (stream-head result))
                 (display ((term-freezer) query))
                 (newline)
                 (sleep 0.01)
                 (map (lambda (pair)
                        (unbind! (car pair))
                        (void))
                      (stream-head result))
                 (loop (stream-tail result)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interact (consult "basics.spl") '(qsort-benchmark x))
