;; Auxiliary

(define-syntax push!
  (syntax-rules ()
    ((push! place value)
     (let ((value* value))
       (set! place (cons value* place))
       value*))))

(define-syntax pop!
  (syntax-rules ()
    ((pop! place)
     (let* ((place* place)
            (value (car place*)))
       (set! place (cdr place*))
       value))))


;; Abstract syntax

(define (bind! variable value) (set-car! variable value) variable)
(define (unbind! variable) (bind! variable variable))
(define (make-variable) (unbind! (cons #f #f)))
(define variable? pair?)
(define (dereference variable)
  (if (variable? variable)
      (let ((value (car variable)))
        (if (eq? variable value)
            value
            (dereference value)))
      variable))

(define (make-compound name . args)
  (let ((vec (make-vector (+ 2 (length args)))))
    (vector-set! vec 0 name)
    (vector-set! vec 1 (length args))
    (loop ((for i (up-from 2))
           (for e (in-list args)))
          (vector-set! vec i e))
    vec))
(define (compound-name compound) (vector-ref compound 0))
(define (compound-arity compound) (vector-ref compound 1))
(define (compound-functor compound) (cons (compound-name compound)
                                          (compound-arity compound)))
(define (compound-arg compound i) (vector-ref compound (+ i 2)))
(define (compound-arg* compound i) (dereference (compound-arg compound i)))
(define-syntax in-compound
  (syntax-rules (backwards)
    ((in-compound (arg-variable) (compound-expression) next . rest)
     (next (((compound) compound-expression))
           ((i 0 (+ i 1)))
           (((args) (compound-arity compound)))
           ((= i args))
           (((arg-variable) (compound-arg compound i)))
           ()
           . rest))
    ((in-compound (arg-variable) (compound-expression (backwards)) next . rest)
     (next (((compound) compound-expression))
           ((i (- (compound-arity compound) 1) (- i 1)))
           ()
           ((< i 0))
           (((arg-variable) (compound-arg compound i)))
           ()
           . rest))))
(define (compound-args compound)
  (loop ((for arg (in-compound compound))
         (for result (listing arg))) => result))
(define compound? vector?)
(define (equal-functors? t-1 t-2)
  (and (equal? (compound-name t-1) (compound-name t-2))
       (= (compound-arity t-1) (compound-arity t-2))))
(define (functor? name arity compound)
  (and (equal? name (compound-name compound))
       (= arity (compound-arity compound))))


;; Thaw and freeze

(define (term-thawer)
  (let ((names '()))
    (letrec ((fresh (lambda (name)
                      (cond ((assoc name names) => cdr)
                            (else
                             (cdr (push! names (cons name (make-variable))))))))
             (thaw (lambda (term)
                     (cond ((symbol? term) (fresh term))
                           ((number? term)
                            (make-compound term))
                           ((pair? term)
                            (apply make-compound (car term) (map thaw (cdr term))))
                           (else
                            (error 'unhanded-data-type))))))
      thaw)))

(define (term-freezer)
  (let ((counter 0)
        (variables '()))
    (letrec ((gensym (lambda ()
                       (set! counter (+ counter 1))
                       (string->symbol (string-append "V" (number->string counter)))))
             (substitute (lambda (variable)
                           (cond ((assq variable variables) => cdr)
                                 (else
                                  (cdr (push! variables (cons variable (gensym))))))))
             (freeze (lambda (term)
                       (let ((term (dereference term)))
                         (if (variable? term)
                             (substitute term)
                             (cons (compound-name term) (map freeze (compound-args term))))))))
      freeze)))


;; Unification

(define (occurs? variable term)
  (let ((term (dereference term)))
    (if (variable? term)
        (eq? term variable)
        (loop continue ((for arg (in-compound term)))
              => #f
              (if (occurs? variable arg)
                  #t
                  (continue))))))

(define (unify lefts rights)
  (define (cons/fail car cdr?)
    (cond (cdr? (cons car cdr?))
          (else (unbind! car) #f)))
  (if (null? lefts)
      '()
      (let ((lhs (dereference (car lefts)))
            (rhs (dereference (car rights))))
        (cond ((and (compound? lhs) (compound? rhs))
               (if (equal-functors? lhs rhs)
                   (loop ((for left (in-compound lhs (backwards)))
                          (for right (in-compound rhs (backwards)))
                          (with lefts (cdr lefts) (cons left lefts))
                          (with rights (cdr rights) (cons right rights)))
                         => (unify lefts rights))
                   #f))
              ((not (variable? lhs)) (unify rights lefts))
              ((eq? lhs rhs)         (unify (cdr lefts) (cdr rights)))
              ((occurs? lhs rhs)     #f)
              (else                  (bind! lhs rhs)
               (cons/fail lhs (unify (cdr lefts) (cdr rights))))))))

;; (define (test-unify left right)
;;   (let* ((thawer (term-thawer))
;;          (left* (thawer left))
;;          (right* (thawer right)))
;;     (if (unify (list left*) (list right*))
;;         ((term-freezer) left*)
;;         #f)))


;; Execution

(define-record-type :conjunct
  (make-conjunct term procedure choice)
  conjunct?
  (term term)
  (procedure procedure)
  (choice choice set-choice!))

(define-record-type :choicepoint
  (make-choicepoint query bindings)
  choicepoint?
  (query query set-query!)
  (bindings bindings set-bindings!))

(define (undo-bindings! choicepoint)
  (for-each unbind! (bindings choicepoint))
  (set-bindings! choicepoint '()))
(define (add-bindings! choicepoint new-bindings)
  (set-bindings! choicepoint (append new-bindings (bindings choicepoint)))) ;; flip args to append?
(define (stack-add-bindings! stack new-bindings)
  (if (null? stack)
      (void)
      (add-bindings! (car stack) new-bindings)))
(define (decrease-choice! conjunct)
  (let ((ch (- (choice conjunct) 1)))
    (set-choice! conjunct ch)
    ch))
(define (copy-conjunct conjunct)
  (make-conjunct (term conjunct)
                 (procedure conjunct)
                 (choice conjunct)))

(define +relations+ '())
(define (lookup functor)
  (cond ((assoc functor +relations+) => cdr)
        (else (cons (lambda (term query stack choice) (error 'should-never-be-called)) 0))))
(define (term->conjunct term)
  (let ((l (lookup (compound-functor term))))
    (make-conjunct term (car l) (cdr l))))
(define-syntax define-relation
  (syntax-rules ()
    ((define-relation ((<proc> <name> <arity> <choices>) <args> ...) <body> ...)
     (begin (define (<proc> <args> ...) <body> ...)
            (push! +relations+ (cons (cons '<name> <arity>) (cons <proc> <choices>)))
            (void)))))

(define (continue query stack)
  (let ((conjunct (car query)))
    ((procedure conjunct) (term conjunct)
                          (cdr query)
                          stack
                          (choice conjunct))))

(define (failure stack)
  (if (null? stack)
      #f
      (begin
        (undo-bindings! (car stack))
        (if (>= 0 (decrease-choice! (car (query (car stack)))))
            (failure (cdr stack))
            (continue (query (car stack)) stack)))))

(define-relation ((true/0 true 0 1) term query stack choice)
  (continue query stack))

(define-relation ((!/0 ! 0 1) term query stack choice)
  ;; perform a cut
  (continue query stack))

(define-relation ((and/2 and 2 1) term query stack choice)
  (continue (cons (term->conjunct (compound-arg* term 0))
                  (cons (term->conjunct (compound-arg* term 1))
                        query))
            stack))

(define-syntax <-
  (syntax-rules ()
    ((<- <it> <cond> <then> <else>)
     (let ((<it> <cond>)) (if <it> <then> <else>)))))

(define-syntax clauses
  (syntax-rules ()
    ((clauses <choice> ((<index> <name>) <body> ...) ...)
     (letrec ((<name> (lambda () <body> ...)) ...)
       (case <choice>
         ((<index>) (<name>)) ...)))))

;; flip(heads).
;; flip(tails).
(define-relation ((flip/1 flip 1 2) term query stack choice)
  (clauses choice
    ((2 clause-2)
     (<- bindings (unify (list (compound-arg term 0)) (list (make-compound 'heads)))
         (continue query (cons (make-choicepoint (cons (make-conjunct term flip/1 2) query) bindings) stack))
         (clause-1)))
    ((1 clause-1)
     (<- bindings (unify (list (compound-arg term 0)) (list (make-compound 'tails)))
         (begin
           (stack-add-bindings! stack bindings)
           (continue query stack))
         (failure stack)))))

;; member(X,cons(X,XS)).
;; member(X,cons(E,XS)) :- member(X,XS).
(define-relation ((member/2 member 2 2) term query stack choice)
  (clauses choice
    ((2 clause-2)
     (<- bindings (unify (list term)
                         (list ((term-thawer) '(member x (cons x xs)))))
         (continue query (cons (make-choicepoint (cons (make-conjunct term member/2 2) query) bindings) stack))
         (clause-1)))
    ((1 clause-1)
     (let ((thaw (term-thawer)))
       (<- bindings (unify (list term)
                           (list (thaw '(member x (cons e xs)))))
           (begin
             (stack-add-bindings! stack bindings)
             (continue (cons (make-conjunct (thaw '(member x xs)) member/2 2) query) stack))
           (failure stack))))))


;;

(define (interact query)
  (let* ((q ((term-thawer) query))
         (nub (make-conjunct #f (lambda (term query stack choice) stack) 1)))
    (let ((result (continue (list (term->conjunct q) nub) '())))
      (display ((term-freezer) q))
      (newline)
      (let loop ((result result))
        (if (equal? 'ok (read))
            (let ((result (failure result)))
              (if result
                  (begin
                    (display ((term-freezer) q)) (newline)
                    (loop result))
                  (void)))
            (void))))))




