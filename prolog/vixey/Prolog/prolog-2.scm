;; mzscheme
;; (require (lib "69.ss" "srfi"))

;; SISC
;; (require-library 'sisc/libs/srfi/srfi-69)
;; (import srfi-69)

;; Chicken
;; csc prolog.scm -require-extension syntactic-closures

;; mit-scheme


;; Utilities

(define-syntax push!
  (syntax-rules ()
    ((push! <value> <place>)
     (set! <place> (cons <value> <place>)))))

(define (last list)
  (if (or (null? list) (null? (cdr list)))
      list
      (last (cdr list))))

(define (assoc-push-back! alist key value)
  ;; may mutate or return a new assoc list
  ;; usage: (set! x (assoc-push-back x k v))
  (let ((existing (assoc key alist)))
    (cond (existing (set-cdr! (last existing) (cons value '()))
                    alist)
          (else (cons (cons key (list value)) alist)))))

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

(define (node-freshener assoc make-fresh)
  (let ((symms '()))
    (lambda (elt)
      (cond ((assoc elt symms) => cdr)
            (else (let ((symm (make-fresh)))
                    (push! (cons elt symm) symms)
                    symm))))))

;; Cuttable streams, for !/0

(define empty-stream '())
(define (empty-stream? stream) (or (null? stream) (not stream)))

(define-syntax cuttable-stream-cons
  (syntax-rules () ((cuttable-stream-cons x y) (cons (cons x #f) (lambda () y)))))

(define-syntax cuttable-stream-cutting-cons
  (syntax-rules () ((cuttable-stream-cutting-cons x y) (cons (cons x #t) (lambda () y)))))

(define (cuttable-stream-head stream)      (caar stream))
(define (cuttable-stream-head-cut? stream) (cdar stream))
(define (cuttable-stream-tail stream)      ((cdr stream)))

(define (cuttable-stream-append-tail stream tail)
  (if (empty-stream? stream)
      (if stream
          (tail)
          stream)
      (if (cuttable-stream-head-cut? stream)
          stream
          (cuttable-stream-cons (cuttable-stream-head stream)
                                (cuttable-stream-append-tail
                                 (cuttable-stream-tail stream) tail)))))

(define (cuttable-stream-apply-cut! cut? stream)
  (if cut?
      (if (empty-stream? stream)
          #f
          (cuttable-stream-cutting-cons (cuttable-stream-head stream)
                                        (cuttable-stream-tail stream)))
      stream))

;; Terms of the language, variables and compounds

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

(define (numeric-value term)
  (let ((value (dereference term)))
    (if (and (compound? value)
             (= 0 (compound-arity value))
             (number? (compound-name value)))
        (compound-name value)
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

(define (copy-term term)
  (cond ((unbound-variable? term) (make-variable)) ;; BUG HERE
        ((variable? term) (copy-term (dereference term)))
        ((compound? term) (make-compound (compound-name term)
                                         (map copy-term (compound-parameters term))))))

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
                    ((numeric-value term) (compound-name term))
                    ((equal-terms? term (make-compound '! '())) '!)
                    ((compound? term)
                     (cons (compound-name term) (map freeze-term
                                                     (compound-parameters term))))))))
    freeze-term))

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

;; Programs are consulted via a database of declarations

(define (compile-declaration declaration)
  ;; declaration: (to-derive (<name> <bindings> ...) <body> ...)
  ;;    compiled: (<name> <arity> <thunk>)
  ;; (<thunk>) ==> (<head-compound> . <body>) ;; with fresh variables every time
  (define (fold-body terms)
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
            (cons (make-compound (car (cadr declaration))
                                 (map term-converter (cdr (cadr declaration))))
                  (fold-body (map term-converter (cddr declaration))))))))

(define (make-declarationbase)
  (make-hash-table))

(define (add-declaration base compiled-declaration)
  (hash-table-update!/default base
   (car compiled-declaration)
   (lambda (entry)
     (assoc-push-back! entry (cadr compiled-declaration) (caddr compiled-declaration)))
   '()))

(define (declarationbase-lookup base name arity)
  (let ((clauses (assoc arity (hash-table-ref/default base name '()))))
    (if clauses (cdr clauses) '())))

(define (consult file)
  (let ((base (make-declarationbase)))
    (call-with-input-file file
      (lambda (port)
        (let loop ((object (read port)))
          (if (eof-object? object)
              base
              (begin (add-declaration base (compile-declaration object))
                     (loop (read port)))))))))

;; Prolog interpreter

(define equate cons)
(define equation-lhs car)
(define equation-rhs cdr)

(define (occurs? unbound-variable term)
  (cond ((unbound-variable? term)
                          (equal-variables? unbound-variable term))
        ((variable? term) (occurs? unbound-variable (dereference term)))
        ((compound? term) (let loop ((parameters (compound-parameters term)))
                            (and (not (null? parameters))
                                 (or (occurs? unbound-variable (car parameters))
                                     (loop (cdr parameters))))))))

(define (unify equations)
  (define (cons/fail car cdr) (if cdr (cons car cdr) (begin (unbind! car) cdr)))
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
              (else (bind! lhs rhs)
                    (cons/fail lhs (unify (cdr equations))))))))

(define primitives '())

(define (primitive? functor arity)
  (let loop ((primitives primitives))
    (if (null? primitives)
        #f
        (if (and (equal? functor (car (car primitives)))
                 (= arity (cadr (car primitives))))
            (caddr (car primitives))
            (loop (cdr primitives))))))

(define (*define-primitive name arity procedure)
  (push! (list name arity procedure) primitives))

(define-syntax define-primitive
  (syntax-rules ()
    ((define-primitive <base> (<name> <bindings> ...) <body> ...)
     (*define-primitive '<name>
                        (length '(<bindings> ...))
                        (lambda (<base> <bindings> ...) <body> ...)))))

(define-primitive _ (true) (cuttable-stream-cons '() empty-stream))
(define-primitive _ (!)    (cuttable-stream-cutting-cons '() empty-stream))

(define (prove base query)
  (set! query (dereference query))
  (cond ((and (compound? query)
              (primitive? (compound-name query) (compound-arity query)))
         => (lambda (primitive)
              (apply primitive base (compound-parameters query))))
        ((numeric-value query)
         => (lambda (number)
              (let loop ((number number))
                (if (<= number 0)
                    empty-stream
                    (cuttable-stream-cons '() (loop (- number 1)))))))
        ((and (equal? 'and (compound-name query))
              (= 2 (compound-arity query)))
         (let ((goal-1 (car (compound-parameters query)))
               (goal-2 (cadr (compound-parameters query))))
           (let loop ((results (prove base goal-1)))
             (if (empty-stream? results)
                 empty-stream
                 (let ((results-2 (prove base goal-2)))
                   (cuttable-stream-append-tail
                    (cuttable-stream-apply-cut!
                     (cuttable-stream-head-cut? results)
                     results-2)
                    (lambda ()
                      (loop (cuttable-stream-tail results)))))))))
        (else
         (let loop ((clauses (declarationbase-lookup base
                               (compound-name query) (compound-arity query))))
           (if (null? clauses)
               empty-stream
               (let* ((clause ((car clauses)))
                      (attempt (unify (list (equate query (car clause))))))
                 (if attempt
                     (cuttable-stream-append-tail
                      (prove base (cdr clause))
                      (lambda ()
                        (map unbind! attempt)
                        (loop (cdr clauses))))
                     (loop (cdr clauses)))))))))

(define success (cuttable-stream-cons '() empty-stream))
(define failure empty-stream)
(define (lift-boolean boolean) (if boolean success failure))
(define (perform-assignment place value)
  (let ((result (unify (list (equate place value)))))
    (if result
        (cuttable-stream-cons '() (begin (map unbind! result) empty-stream))
        failure)))

(define-primitive _ (var x)      (lift-boolean (unbound-variable? x)))
(define-primitive _ (nonvar x)   (lift-boolean (not (unbound-variable? x))))
(define-primitive _ (atom x)     (lift-boolean (and (compound? x) (= (compound-arity x) 0))))
(define-primitive _ (compound x) (lift-boolean (and (compound? x) (> (compound-arity x) 0))))
(define-primitive _ (number x)   (lift-boolean (numeric-value x)))
(define-primitive _ (copy-term x y) (perform-assignment y (copy-term x)))
(define-primitive _ (read term)     (perform-assignment term ((make-term-converter) (read))))
(define-primitive _ (display term)  (display ((term-freezer) term)) (newline)
  success)

(define-primitive base (find-all subterm query results)
  (perform-assignment
   results
    (let loop ((result (prove base query)))
      (if (empty-stream? result)
          (make-compound 'nil '())
          (make-compound 'cons (list (copy-term subterm) (loop (cuttable-stream-tail result))))))))

(define-primitive base (clause head body)
  (let loop ((clauses (declarationbase-lookup base
                        (compound-name head) (compound-arity head))))
    (if (null? clauses)
        failure
        (let* ((clause ((car clauses)))
               (result (unify (list (equate head (car clause))))))
          (if result
              (let ((body-result (unify (list (equate body (cdr clause))))))
                (if body-result
                    (cuttable-stream-cons '()
                                 (begin (map unbind! result)
                                        (map unbind! body-result)
                                        (loop (cdr clauses))))
                    (begin (map unbind! result)
                           (loop (cdr clauses)))))
              (loop (cdr clauses)))))))

(define-syntax define-numeric-comparison-operator
  (syntax-rules ()
    ((define-comparison-operator <name> <operator>)
     (define-primitive _ (<name> x y)
       (let ((x (numeric-value x)) (y (numeric-value y)))
         (lift-boolean (and x y (<operator> x y))))))))

(define-numeric-comparison-operator < <)
(define-numeric-comparison-operator =< <=)
(define-numeric-comparison-operator > >)
(define-numeric-comparison-operator >= >=)


(define-syntax define-numeric-binary-op-primitive
  (syntax-rules ()
    ((define-binary-op-primitive <name> <operator>)
     (define-primitive _ (<name> x y z)
       (let ((x (numeric-value x)) (y (numeric-value y)))
         (if (and x y)
             (perform-assignment z (make-compound (<operator> x y) '()))
             failure))))))

(define-numeric-binary-op-primitive %+ +)
(define-numeric-binary-op-primitive %- -)
(define-numeric-binary-op-primitive %* *)
(define-numeric-binary-op-primitive %/ /)
(define-numeric-binary-op-primitive %** expt)
(define-numeric-binary-op-primitive %mod modulo)
(define-numeric-binary-op-primitive %rem remainder)


(define-syntax define-numeric-unary-op-primitive
  (syntax-rules ()
    ((define-numeric-unary-op-primitive <name> <operator>)
     (define-primitive _ (<name> x y)
       (let ((x (numeric-value x)))
         (if x
             (perform-assignment y (make-compound (<operator> x) '()))
             failure))))))

(define-numeric-unary-op-primitive %sqrt sqrt)
(define-numeric-unary-op-primitive %sin sin)
(define-numeric-unary-op-primitive %cos cos)
(define-numeric-unary-op-primitive %tan tan)
(define-numeric-unary-op-primitive %asin asin)
(define-numeric-unary-op-primitive %acos acos)
(define-numeric-unary-op-primitive %atan atan)
(define-numeric-unary-op-primitive %abs abs)
(define-numeric-unary-op-primitive %floor floor)
(define-numeric-unary-op-primitive %round round)
(define-numeric-unary-op-primitive %ceiling ceiling)


(define (interact base)
  (display "?- ")
  (let* ((query ((make-term-converter) (read))))
    (if (variable? query)
        'done
        (let loop ((results (prove base query)))
          (cond ((empty-stream? results)
                 (display "no")
                 (newline)
                 (interact base))
                (else
                 (display ((term-freezer) query))
                 (newline)
                 (display "more? ")
                 (case (read)
                   ((more) (loop (cuttable-stream-tail results)))
                   (else (interact base)))))))))

(interact (consult "basics.spl"))




































;; (define failure cuttable-empty-stream)

;; (define success (cuttable-stream-cons (make-reversible-action (lambda () '())
;;                                                               (lambda () '()))
;;                                       cuttable-empty-stream))


;; (define (disjunction heads tails)
;;   (cut-stream-append heads (tails)))

;; (define (conjunction heads tails)
;;   (map (lambda (head) (cut-stream-cons head tails)) heads))


;; (define (unification-action lhs rhs)
;;   (make-reversible-action ...))


;; (define (prove base query)
;;   (cond
;;    ((primitive) => force)
   
;;    ((equal? 'true/0 (compound-functor query))
;;     success)
   
;;    ((equal? '!/0 (compound-functor query))
;;     (cut! success))
   
;;    ((equal? 'and/2 (compound-functor query))
;;     (conjunction (prove base (car (compound-parameters query)))
;;                  (delay (prove base (cadr (compound-parameters query))))))
   
;;    (else
;;     (let clause-loop ((clauses (lookup base query)))
;;       (let* ((clause (car clauses)))
;;         (disjunction (conjunction (perform-unification query (clause-head clause))
;;                                   (delay (prove base (clause-body clause))))
;;                      (delay (clause-loop (cdr clauses)))))))))



;; ;; clause-head
;; ;; clause-body

