;; csc Prolog.scm

;;(declare (unit prolog))
(require-for-syntax "riaxpander")
(require-for-syntax "foof-loop")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(define (fold f z l)
  (if (null? l)
      z
      (f (car l) (fold f z (cdr l)))))

(define (compose f g) (lambda (x) (f (g x))))
;;(define (compose . functions) (fold (lambda (f g) (lambda (x) (f (g x)))) (lambda (i) i) functions))

(define (symbol->number symbol) (string->number (symbol->string symbol)))
(define (number->symbol symbol) (string->symbol (number->string symbol)))


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
(define (compound-add-args compound . args)
  (apply make-compound (compound-name compound) (append (compound-args compound) args)))


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
  (make-conjunct term procedure choice cut-index)
  conjunct?
  (term term)
  (procedure procedure)
  (choice choice set-choice!)
  (cut-index cut-index))

(define-record-type :choicepoint
  (make-choicepoint query bindings)
  choicepoint?
  (query query set-query!)
  (bindings bindings set-bindings!))

(define (undo-bindings! choicepoint)
  (for-each unbind! (bindings choicepoint))
  (set-bindings! choicepoint '()))
(define (add-bindings! choicepoint new-bindings)
  ;; flip args to append?
  (set-bindings! choicepoint (append new-bindings (bindings choicepoint))))
(define (stack-add-bindings! stack new-bindings)
  (if (null? stack)
      (void)
      (add-bindings! (car stack) new-bindings)))
(define (decrease-choice! conjunct)
  (let ((ch (- (choice conjunct) 1)))
    (set-choice! conjunct ch)
    ch))
(define (copy-conjunct conjunct)
  ;; not used
  (make-conjunct (term conjunct)
                 (procedure conjunct)
                 (choice conjunct)
                 (cut-index conjunct)))

(define (continue query stack height)
  
;;   (let ((it (dereference (term (car query)))))
;;     (and it
;;          (let ((freeze (term-freezer)))
;;            (display `(continue enters into (,(compound-name it) . ,(map freeze (compound-args it)))))))
;;     (newline))
  
  (let ((conjunct (car query)))
    ((procedure conjunct) (term conjunct)
                          (cdr query)
                          stack
                          height
                          (choice conjunct)
                          (cut-index conjunct))))

(define (failure stack height)
  (if (null? stack)
      #f
      (begin
        (undo-bindings! (car stack))
        (if (>= 0 (decrease-choice! (car (query (car stack)))))
            (failure (cdr stack) (- height 1))
            (continue (query (car stack)) stack height)))))

;; Please replace this with something else...
(define (interact query)
  (define (read&chomp)
    (let ((e (read)))
      (if (char=? #\newline (peek-char)) (read-char) (void))
      e))
  (let* ((q ((term-thawer) query))
         (nub (make-conjunct #f (lambda (term query stack height choice cut-index) stack) 1 0)))
    (let ((result (continue (list (term->conjunct q 0) nub) '() 0)))
      (cond (result
             (display ((term-freezer) q))
             (newline)
             (let loop ((result result))
               (display "more? ")
               (if (equal? 'ok (read&chomp))
                   (let ((result (failure result (length result))))
                     (if result
                         (begin
                           (display ((term-freezer) q)) (newline)
                           (loop result))
                         (void)))
                   (void))))
            (else (display 'no) (newline))))))

(define +relations+ '())

(define (lookup functor)
  (cond ((assoc functor +relations+) => cdr)
        (else (cons (lambda (term query stack height choice cut-index)
                      (display (compound-name (dereference term)))
                      (display '/)
                      (display (length (compound-args (dereference term))))
                      (newline)
                      (error 'should-never-be-called))
                    0))))

(define (term->conjunct term cut-index)
  (let ((l (lookup (compound-functor term))))
    (make-conjunct term (car l) (cdr l) cut-index)))

(define-syntax define-relation
  (syntax-rules ()
    ((define-relation ((<proc> <name> <arity> <choices>) <args> ...) <body> ...)
     (begin (define (<proc> <args> ...) <body> ...)
            (push! +relations+ (cons (cons '<name> <arity>) (cons <proc> <choices>)))
            (void)))))

(define-syntax alias-relation
  (syntax-rules ()
    ((alias-relation <proc> (<proc2> <name> <arity> <choices>))
     (begin (define <proc2> <proc>)
            (push! +relations+ (cons (cons '<name> <arity>) (cons <proc> <choices>)))
            (void)))))

(define-syntax define-question
  (syntax-rules ()
    ((define-question (<proc> <arity>)
       (<name> <args> ...)
       <body> ...)
     (define-relation ((<proc> <name> <arity> 1) term query stack height choice cut-index)
       (if (apply (lambda (<args> ...) <body> ...) (compound-args term))
           (continue query stack height)
           (failure stack height))))))

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


;; The primitives

(define-relation ((and/2 and 2 1) term query stack height choice cut-index)
  (continue (cons (term->conjunct (compound-arg* term 0) cut-index)
                  (cons (term->conjunct (compound-arg* term 1) cut-index)
                        query))
            stack
            height))

(alias-relation and/2 (|,/2| |,| 2 1))

(define-relation ((or/2 or 2 2) term query stack height choice cut-index)
  (if (= choice 2)
      (continue (cons (term->conjunct (compound-arg* term 0) cut-index) query)
                (cons (make-choicepoint (cons (make-conjunct (make-compound 'or #f (compound-arg* term 1)) or/2 2 cut-index) query) '()) stack)
                (+ 1 height))
      (continue (cons (term->conjunct (compound-arg* term 1) cut-index) query)
                stack
                height)))

;;(alias-relation or/2 (|;/2| |;| 2 2))

(define-relation ((call/1 call 1 1) term query stack height choice cut-index)
  (continue (cons (term->conjunct (compound-arg* term 0) (+ 1 cut-index)) query) stack height))

(define-relation ((call/3 call 3 1) term query stack height choice cut-index)
  (continue (cons (term->conjunct (compound-add-args (compound-arg* term 0) (compound-arg* term 1) (compound-arg* term 2))
                                  (+ 1 cut-index))
                  query) stack height))

(define-relation ((!/0 ! 0 1) term query stack height choice cut-index)
  (let loop ((stack stack) (cuts (- height cut-index)))
    (cond ((<= cuts 0)
           (continue query stack cut-index))
          (else
           (stack-add-bindings! (cdr stack) (bindings (car stack)))
           (loop (cdr stack) (- cuts 1))))))

(define-relation ((fail/0 fail 0 1) term query stack height choice cut-index)
  (failure stack height))

(define prolog-nil (make-compound '|[]|))
(define (prolog-cons car cdr) (make-compound '|.| car cdr))

(define (list->prolog-term list)
  (fold prolog-cons prolog-nil list))

(define (prolog-term->list term)
  (let ((term (dereference term)))
    (if (functor? '|[]| 0 term)
        '()
        (cons (compound-arg* term 0)
              (prolog-term->list (compound-arg* term 1))))))

(define (string->prolog-term string)
  (list->prolog-term (map (compose make-compound (compose number->symbol char->integer)) (string->list string))))

(define-relation ((=../2 =.. 2 1) term query stack height choice cut-index)
  (let ((term (compound-arg* term 0))
        (splay (compound-arg* term 1)))
    (cond ((not (variable? term))
           (<- bindings (unify (list (list->prolog-term (cons (make-compound (compound-name term)) (compound-args term))))
                               (list splay))
               (begin (stack-add-bindings! stack bindings)
                      (continue query stack height))
               (failure stack height)))
          ((not (variable? splay))
           (let ((list (prolog-term->list splay)))
             (bind! term (apply make-compound (compound-name (car list)) (cdr list))))
           (stack-add-bindings! stack (list term))
           (continue query stack height))
          (else
           (error 'arguments-insufficiently-instantiated)))))

(define-question (var/1 1)
  (var v)
  (variable? (dereference v)))

(define-question (compound/1 1)
  (compound c)
  (compound? (dereference c)))

(define-question (atomic/1 1)
  (atomic a)
  (= 0 (compound-arity (dereference a))))

(define-relation ((read_line/1 read_line 1 1) term query stack height choice cut-index)
  (let ((line (string->prolog-term (read-line))))
    (<- bindings (unify (list line) (list (compound-arg* term 0)))
        (begin (stack-add-bindings! stack bindings)
               (continue query stack height))
        (failure stack height))))

(define-relation ((write_char/1 write_char 1 1) term query stack height choice cut-index)
  (write-char (integer->char (symbol->number (compound-name (compound-arg* term 0)))))
  (continue query stack height))

(define-relation ((atom_codes/2 atom_codes 2 1) term query stack height choice cut-index)
  (let ((atom (compound-arg* term 0))
        (codes (compound-arg* term 1)))
    (cond ((not (variable? atom))
           (let ((atom-codes (string->prolog-term (symbol->string (compound-name atom)))))
             (<- bindings (unify (list atom-codes) (list codes))
                 (begin (stack-add-bindings! stack bindings)
                        (continue query stack height))
                 (failure stack height))))
          ((not (variable? codes))
           (bind! atom (make-compound
                        (string->symbol
                         (list->string
                          (map (lambda (t) (integer->char (symbol->number (compound-name t))))
                               (prolog-term->list codes))))))
           (stack-add-bindings! stack (list atom))
           (continue query stack height))
          (else
           (error 'arguments-insufficiently-instantiated)))))

(define-relation ((succ/2 succ 2 1) term query stack height choice cut-index)
  (let ((z (compound-arg* term 0))
        (s (compound-arg* term 1)))
    (cond ((not (variable? z))
           (let ((n (+ (symbol->number (compound-name z)) 1)))
             (<- bindings (unify (list s) (list (make-compound (number->symbol n))))
                 (begin (stack-add-bindings! stack bindings)
                        (continue query stack height))
                 (failure stack height))))
          ((not (variable? s))
           (let ((n (- (symbol->number (compound-name s)) 1)))
             (bind! z (make-compound (number->symbol n)))
             (stack-add-bindings! stack (list z))
             (continue query stack height)))
          (else
           (error 'arguments-insufficiently-instantiated)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-relation ((true/0 true 0 1) term query stack height choice cut-index) (continue query stack height))

(define-relation ((=/2 = 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(= V0 V0)))) (begin (stack-add-bindings! stack bindings) (continue query stack height)) (failure stack height))))

(define-relation ((|\\=/2| |\\=| 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(|\\=| V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|\\+| (= V0 V1))) height) query) stack height)) (failure stack height))))

 (define-relation ((|;/2| |;| 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(|;| (|->| V0 V1) V2)))) (continue (cons (term->conjunct (thaw '(|,| (!) (|;| (|,| (call V0) (|,| (!) (call V1))) (call V2)))) height) query) (cons (make-choicepoint (cons (make-conjunct term |;/2| 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(|;| V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(or V0 V1)) height) query) stack height)) (failure stack height))))))

(define-relation ((=>/2 => 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(=> V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|\\+| (|,| (call V0) (|\\+| (call V1))))) height) query) stack height)) (failure stack height))))

(define-relation ((|\\+/1| |\\+| 1 3) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(|\\+| V0)))) (continue (cons (term->conjunct (thaw '(|,| (call V0) (|,| (!) (fail)))) height) query) (cons (make-choicepoint (cons (make-conjunct term |\\+/1| 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(|\\+| V0)))) (if (= choice 3) (continue query (cons (make-choicepoint (cons (make-conjunct term |\\+/1| 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue query stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(|\\+| (|,| (= V0 (chalk)) (= V1 (cheese))))))) (begin (stack-add-bindings! stack bindings) (continue query stack height)) (failure stack height))))))

;; %%TODO functor/3, arg/3

(define-relation ((==/2 == 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(== V0 V1)))) (continue (cons (term->conjunct (thaw '(|,| (var V0) (var V1))) height) query) (cons (make-choicepoint (cons (make-conjunct term ==/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(== V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (functor V0 V2 V3) (|,| (functor V1 V2 V3) (=> (|,| (arg V4 V0 V5) (arg V4 V1 V6)) (== V5 V6))))) height) query) stack height)) (failure stack height))))))

(define-relation ((list/1 list 1 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(list (|[]|))))) (continue query (cons (make-choicepoint (cons (make-conjunct term list/1 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(list (|.| (_) (_)))))) (begin (stack-add-bindings! stack bindings) (continue query stack height)) (failure stack height))))))

(define-relation ((member/2 member 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(member V0 (|.| V0 (_)))))) (continue query (cons (make-choicepoint (cons (make-conjunct term member/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(member V0 (|.| (_) V1))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(member V0 V1)) height) query) stack height)) (failure stack height))))))

(define-relation ((append/3 append 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(append (|[]|) V0 V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term append/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(append (|.| V0 V1) V2 (|.| V0 V3))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(append V1 V2 V3)) height) query) stack height)) (failure stack height))))))

(define-relation ((select/3 select 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(select V0 (|.| V0 V1) V1)))) (continue query (cons (make-choicepoint (cons (make-conjunct term select/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(select V0 (|.| V1 V2) (|.| V1 V3))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(select V0 V2 V3)) height) query) stack height)) (failure stack height))))))

(define-relation ((maplist/3 maplist 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(maplist V0 (|[]|) (|[]|))))) (continue query (cons (make-choicepoint (cons (make-conjunct term maplist/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(maplist V0 (|.| V1 V2) (|.| V3 V4))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (call V0 V1 V3) (maplist V0 V2 V4))) height) query) stack height)) (failure stack height))))))



(define-relation ((nthq/3 nthq 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(nthq (|0|) V0 (|.| V1 V2))))) (continue (cons (term->conjunct (thaw '(== V0 V1)) height) query) (cons (make-choicepoint (cons (make-conjunct term nthq/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(nthq V0 V1 (|.| V2 V3))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (nthq V4 V1 V3) (succ V4 V0))) height) query) stack height)) (failure stack height))))))

(define-relation ((variables/2 variables 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(variables V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(variables V0 V1 (|[]|))) height) query) stack height)) (failure stack height))))

(define-relation ((variables/3 variables 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(variables V0 V1 V2)))) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (var V0) (!)) (= V3 V1)) (= V3 (|.| V0 V2)))) height) query) (cons (make-choicepoint (cons (make-conjunct term variables/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(variables V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (=.. V0 (|.| V3 V4)) (= V5 V1)) (list_variables V4 V5 V2))) height) query) stack height)) (failure stack height))))))

(define-relation ((list_variables/3 list_variables 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(list_variables (|[]|) V0 V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term list_variables/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(list_variables (|.| V0 V1) V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (variables V0 V2 V4) (list_variables V1 V4 V3))) height) query) stack height)) (failure stack height))))))

(define-relation ((write_chars/1 write_chars 1 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(write_chars (|[]|))))) (continue query (cons (make-choicepoint (cons (make-conjunct term write_chars/1 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(write_chars (|.| V0 V1))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (write_char V0) (write_chars V1))) height) query) stack height)) (failure stack height))))))

(define-relation ((write_atom/1 write_atom 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(write_atom V0)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (atom_codes V0 V1) (write_chars V1))) height) query) stack height)) (failure stack height))))

(define-relation ((write_term/1 write_term 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(write_term V0)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (flatten V0 V1 (|[]|)) (write_term_list V1 (|[]|)))) height) query) stack height)) (failure stack height))))

(define-relation ((flatten/3 flatten 3 4) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((4 clause-4) (<- bindings (unify (list term) (list (thaw '(flatten V0 V1 V2)))) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (var V0) (!)) (= V3 V1)) (= V3 (|.| V0 V2)))) height) query) (cons (make-choicepoint (cons (make-conjunct term flatten/3 4 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-3))) ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(flatten V0 V1 V2)))) (if (= choice 4) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (list V0) (!)) (= V3 V1)) (|,| (= V3 (|.| (|[|) V4)) (|,| (flatten_list V0 V4 V5) (= V5 (|.| (|]|) V2)))))) height) query) (cons (make-choicepoint (cons (make-conjunct term flatten/3 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (list V0) (!)) (= V3 V1)) (|,| (= V3 (|.| (|[|) V4)) (|,| (flatten_list V0 V4 V5) (= V5 (|.| (|]|) V2)))))) (|-| height 1)) query) stack height))) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(flatten V0 V1 V2)))) (if (= choice 4) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (=.. V0 (|.| V3 (|[]|))) (!)) (= V4 V1)) (= V4 (|.| V3 V2)))) height) query) (cons (make-choicepoint (cons (make-conjunct term flatten/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (=.. V0 (|.| V3 (|[]|))) (!)) (= V4 V1)) (= V4 (|.| V3 V2)))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(flatten V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (=.. V0 (|.| V3 V4)) (= V5 V1)) (|,| (= V5 (|.| V3 V6)) (|,| (= V6 (|.| (|(|) V7)) (|,| (flatten_args V4 V7 V8) (= V8 (|.| (|)|) V2))))))) height) query) stack height)) (failure stack height))))))

(define-relation ((flatten_list/3 flatten_list 3 4) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((4 clause-4) (<- bindings (unify (list term) (list (thaw '(flatten_list (|[]|) V0 V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term flatten_list/3 4 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-3))) ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(flatten_list (|.| V0 (|[]|)) V1 V2)))) (if (= choice 4) (continue (cons (term->conjunct (thaw '(|,| (|,| (!) (= V3 V1)) (flatten V0 V3 V2))) height) query) (cons (make-choicepoint (cons (make-conjunct term flatten_list/3 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (!) (= V3 V1)) (flatten V0 V3 V2))) (|-| height 1)) query) stack height))) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(flatten_list (|.| V0 V1) V2 V3)))) (if (= choice 4) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (list V1) (!)) (= V4 V2)) (|,| (flatten V0 V4 V5) (|,| (= V5 (|.| (|,|) V6)) (flatten_list V1 V6 V3))))) height) query) (cons (make-choicepoint (cons (make-conjunct term flatten_list/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (|,| (list V1) (!)) (= V4 V2)) (|,| (flatten V0 V4 V5) (|,| (= V5 (|.| (|,|) V6)) (flatten_list V1 V6 V3))))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(flatten_list (|.| V0 V1) V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (flatten V0 V2 V4) (|,| (= V4 (|.| (|\||) V5)) (flatten V1 V5 V3)))) height) query) stack height)) (failure stack height))))))

(define-relation ((flatten_args/3 flatten_args 3 3) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(flatten_args (|[]|) V0 V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term flatten_args/3 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(flatten_args (|.| V0 (|[]|)) V1 V2)))) (if (= choice 3) (continue (cons (term->conjunct (thaw '(|,| (|,| (!) (= V3 V1)) (flatten V0 V3 V2))) height) query) (cons (make-choicepoint (cons (make-conjunct term flatten_args/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (!) (= V3 V1)) (flatten V0 V3 V2))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(flatten_args (|.| V0 (|.| V1 V2)) V3 V4)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (true) (|,| (flatten V0 V3 V5) (|,| (= V5 (|.| (|, |) V6)) (flatten_args (|.| V1 V2) V6 V4))))) height) query) stack height)) (failure stack height))))))

(define-relation ((write_term_list/2 write_term_list 2 4) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((4 clause-4) (<- bindings (unify (list term) (list (thaw '(write_term_list (|[]|) V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term write_term_list/2 4 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-3))) ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(write_term_list (|.| V0 V1) V2)))) (if (= choice 4) (continue (cons (term->conjunct (thaw '(|,| (var V0) (|,| (nthq V3 V0 V2) (|,| (!) (|,| (write_atom (V)) (|,| (write_atom V3) (write_term_list V1 V2))))))) height) query) (cons (make-choicepoint (cons (make-conjunct term write_term_list/2 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (var V0) (|,| (nthq V3 V0 V2) (|,| (!) (|,| (write_atom (V)) (|,| (write_atom V3) (write_term_list V1 V2))))))) (|-| height 1)) query) stack height))) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(write_term_list (|.| V0 V1) V2)))) (if (= choice 4) (continue (cons (term->conjunct (thaw '(|,| (var V0) (|,| (!) (|,| (append V2 (|.| V0 (|[]|)) V3) (write_term_list (|.| V0 V1) V3))))) height) query) (cons (make-choicepoint (cons (make-conjunct term write_term_list/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (var V0) (|,| (!) (|,| (append V2 (|.| V0 (|[]|)) V3) (write_term_list (|.| V0 V1) V3))))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(write_term_list (|.| V0 V1) V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (atomic V0) (|,| (write_atom V0) (write_term_list V1 V2)))) height) query) stack height)) (failure stack height))))))

(define-relation ((nl/0 nl 0 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (continue (cons (term->conjunct (thaw '(write_atom (|
|))) height) query) stack height)))

(define-relation ((lowercase/1 lowercase 1 3) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(lowercase V0)))) (continue (cons (term->conjunct (thaw '(member V0 (|.| (|95|) (|[]|)))) height) query) (cons (make-choicepoint (cons (make-conjunct term lowercase/1 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(lowercase V0)))) (if (= choice 3) (continue (cons (term->conjunct (thaw '(member V0 (|.| (|97|) (|.| (|98|) (|.| (|99|) (|.| (|100|) (|.| (|101|) (|.| (|102|) (|.| (|103|) (|.| (|104|) (|.| (|105|) (|.| (|106|) (|.| (|107|) (|.| (|108|) (|.| (|109|) (|.| (|110|) (|.| (|111|) (|.| (|112|) (|.| (|113|) (|.| (|114|) (|.| (|115|) (|.| (|116|) (|.| (|117|) (|.| (|118|) (|.| (|119|) (|.| (|120|) (|.| (|121|) (|.| (|122|) (|[]|))))))))))))))))))))))))))))) height) query) (cons (make-choicepoint (cons (make-conjunct term lowercase/1 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(member V0 (|.| (|97|) (|.| (|98|) (|.| (|99|) (|.| (|100|) (|.| (|101|) (|.| (|102|) (|.| (|103|) (|.| (|104|) (|.| (|105|) (|.| (|106|) (|.| (|107|) (|.| (|108|) (|.| (|109|) (|.| (|110|) (|.| (|111|) (|.| (|112|) (|.| (|113|) (|.| (|114|) (|.| (|115|) (|.| (|116|) (|.| (|117|) (|.| (|118|) (|.| (|119|) (|.| (|120|) (|.| (|121|) (|.| (|122|) (|[]|))))))))))))))))))))))))))))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(lowercase V0)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(member V0 (|.| (|48|) (|.| (|49|) (|.| (|50|) (|.| (|51|) (|.| (|52|) (|.| (|53|) (|.| (|54|) (|.| (|55|) (|.| (|56|) (|.| (|57|) (|[]|))))))))))))) height) query) stack height)) (failure stack height))))))

(define-relation ((uppercase/1 uppercase 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(uppercase V0)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(member V0 (|.| (|65|) (|.| (|66|) (|.| (|67|) (|.| (|68|) (|.| (|69|) (|.| (|70|) (|.| (|71|) (|.| (|72|) (|.| (|73|) (|.| (|74|) (|.| (|75|) (|.| (|76|) (|.| (|77|) (|.| (|78|) (|.| (|79|) (|.| (|80|) (|.| (|81|) (|.| (|82|) (|.| (|83|) (|.| (|84|) (|.| (|85|) (|.| (|86|) (|.| (|87|) (|.| (|88|) (|.| (|89|) (|.| (|90|) (|[]|))))))))))))))))))))))))))))) height) query) stack height)) (failure stack height))))

(define-relation ((whitespace/1 whitespace 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(whitespace V0)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(member V0 (|.| (|32|) (|.| (|10|) (|[]|))))) height) query) stack height)) (failure stack height))))

(define-relation ((lowercase/3 lowercase 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(lowercase V0 (|.| V0 V1) V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (lowercase V0) (= V2 V1))) height) query) stack height)) (failure stack height))))

(define-relation ((uppercase/3 uppercase 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(uppercase V0 (|.| V0 V1) V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (uppercase V0) (= V2 V1))) height) query) stack height)) (failure stack height))))

(define-relation ((anything/3 anything 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(anything V0 V1 V2)))) (continue (cons (term->conjunct (thaw '(lowercase V0 V1 V2)) height) query) (cons (make-choicepoint (cons (make-conjunct term anything/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(anything V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(uppercase V0 V1 V2)) height) query) stack height)) (failure stack height))))))

(define-relation ((ws/2 ws 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(ws (|.| V0 V1) V2)))) (continue (cons (term->conjunct (thaw '(|,| (|,| (whitespace V0) (= V3 V1)) (ws V3 V2))) height) query) (cons (make-choicepoint (cons (make-conjunct term ws/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(ws V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (!) (= V1 V0))) height) query) stack height)) (failure stack height))))))

(define-relation ((ws1/2 ws1 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(ws1 (|.| V0 V1) V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (whitespace V0) (= V2 V1))) height) query) stack height)) (failure stack height))))

(define-relation ((identifier_string/3 identifier_string 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(identifier_string (|.| V0 V1) V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (lowercase V0 V2 V4) (rest V1 V4 V3))) height) query) stack height)) (failure stack height))))

(define-relation ((variable_name_string/3 variable_name_string 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(variable_name_string (|.| V0 V1) V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (uppercase V0 V2 V4) (rest V1 V4 V3))) height) query) stack height)) (failure stack height))))

(define-relation ((rest/3 rest 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(rest (|.| V0 V1) V2 V3)))) (continue (cons (term->conjunct (thaw '(|,| (anything V0 V2 V4) (rest V1 V4 V3))) height) query) (cons (make-choicepoint (cons (make-conjunct term rest/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(rest (|[]|) V0 V0)))) (begin (stack-add-bindings! stack bindings) (continue query stack height)) (failure stack height))))))

(define-relation ((identifier/3 identifier 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(identifier V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (identifier_string V3 V1 V4) (|,| (atom_codes V0 V3) (= V2 V4)))) height) query) stack height)) (failure stack height))))

(define-relation ((variable_name/3 variable_name 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(variable_name V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (variable_name_string V3 V1 V4) (|,| (atom_codes V0 V3) (= V2 V4)))) height) query) stack height)) (failure stack height))))

(define-relation ((ops/1 ops 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(ops (|.| (|,| (xfx) (|.| (|,| (|-->|) (|.| (|45|) (|.| (|45|) (|.| (|62|) (|[]|))))) (|.| (|,| (:-) (|.| (|58|) (|.| (|45|) (|[]|)))) (|[]|)))) (|.| (|,| (xfy) (|.| (|,| (|;|) (|.| (|59|) (|[]|))) (|[]|))) (|.| (|,| (xfy) (|.| (|,| (|->|) (|.| (|45|) (|.| (|62|) (|[]|)))) (|[]|))) (|.| (|,| (xfx) (|.| (|,| (=>) (|.| (|61|) (|.| (|62|) (|[]|)))) (|[]|))) (|.| (|,| (xfy) (|.| (|,| (|,|) (|.| (|44|) (|[]|))) (|[]|))) (|.| (|,| (fy) (|.| (|,| (|\\+|) (|.| (|92|) (|.| (|43|) (|[]|)))) (|[]|))) (|.| (|,| (xfx) (|.| (|,| (==) (|.| (|61|) (|.| (|61|) (|[]|)))) (|.| (|,| (=) (|.| (|61|) (|[]|))) (|.| (|,| (|\\=|) (|.| (|92|) (|.| (|61|) (|[]|)))) (|.| (|,| (<) (|.| (|60|) (|[]|))) (|.| (|,| (>) (|.| (|62|) (|[]|))) (|[]|))))))) (|.| (|,| (yfx) (|.| (|,| (|+|) (|.| (|43|) (|[]|))) (|.| (|,| (|-|) (|.| (|45|) (|[]|))) (|[]|)))) (|.| (|,| (fx) (|.| (|,| (|-|) (|.| (|45|) (|[]|))) (|[]|))) (|.| (|,| (fy) (|.| (|,| (s) (|.| (|115|) (|[]|))) (|[]|))) (|.| (|,| (yfx) (|.| (|,| (*) (|.| (|42|) (|[]|))) (|[]|))) (|[]|)))))))))))))))) (begin (stack-add-bindings! stack bindings) (continue query stack height)) (failure stack height))))

(define-relation ((ops_below_comma/1 ops_below_comma 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(ops_below_comma (|.| (|,| (fy) (|.| (|,| (|\\+|) (|.| (|92|) (|.| (|43|) (|[]|)))) (|[]|))) (|.| (|,| (xfx) (|.| (|,| (==) (|.| (|61|) (|.| (|61|) (|[]|)))) (|.| (|,| (=) (|.| (|61|) (|[]|))) (|.| (|,| (|\\=|) (|.| (|92|) (|.| (|61|) (|[]|)))) (|.| (|,| (<) (|.| (|60|) (|[]|))) (|.| (|,| (>) (|.| (|62|) (|[]|))) (|[]|))))))) (|.| (|,| (yfx) (|.| (|,| (|+|) (|.| (|43|) (|[]|))) (|.| (|,| (|-|) (|.| (|45|) (|[]|))) (|[]|)))) (|.| (|,| (fx) (|.| (|,| (|-|) (|.| (|45|) (|[]|))) (|[]|))) (|.| (|,| (fy) (|.| (|,| (s) (|.| (|115|) (|[]|))) (|[]|))) (|.| (|,| (yfx) (|.| (|,| (*) (|.| (|42|) (|[]|))) (|[]|))) (|[]|))))))))))) (begin (stack-add-bindings! stack bindings) (continue query stack height)) (failure stack height))))

(define-relation ((plain/3 plain 3 5) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((5 clause-5) (<- bindings (unify (list term) (list (thaw '(plain (variable V0) V1 V2)))) (continue (cons (term->conjunct (thaw '(|,| (ws V1 V3) (variable_name V0 V3 V2))) height) query) (cons (make-choicepoint (cons (make-conjunct term plain/3 5 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-4))) ((4 clause-4) (<- bindings (unify (list term) (list (thaw '(plain (compound V0 V1) V2 V3)))) (if (= choice 5) (continue (cons (term->conjunct (thaw '(|,| (ws V2 V4) (|,| (identifier V0 V4 V5) (|;| (|->| (|,| (ws V5 V6) (= V6 (|.| (|40|) V7))) (|,| (|,| (ops_below_comma V8) (= V9 V7)) (|,| (args V8 V1 V9 V10) (= V10 (|.| (|41|) V3))))) (|,| (= V1 (|[]|)) (= V3 V5)))))) height) query) (cons (make-choicepoint (cons (make-conjunct term plain/3 4 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ws V2 V4) (|,| (identifier V0 V4 V5) (|;| (|->| (|,| (ws V5 V6) (= V6 (|.| (|40|) V7))) (|,| (|,| (ops_below_comma V8) (= V9 V7)) (|,| (args V8 V1 V9 V10) (= V10 (|.| (|41|) V3))))) (|,| (= V1 (|[]|)) (= V3 V5)))))) (|-| height 1)) query) stack height))) (clause-3))) ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(plain (compound (!) (|[]|)) V0 V1)))) (if (= choice 5) (continue (cons (term->conjunct (thaw '(|,| (ws V0 V2) (= V2 (|.| (|33|) V1)))) height) query) (cons (make-choicepoint (cons (make-conjunct term plain/3 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ws V0 V2) (= V2 (|.| (|33|) V1)))) (|-| height 1)) query) stack height))) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(plain (compound (|[]|) (|[]|)) V0 V1)))) (if (= choice 5) (continue (cons (term->conjunct (thaw '(|,| (ws V0 V2) (= V2 (|.| (|91|) (|.| (|93|) V1))))) height) query) (cons (make-choicepoint (cons (make-conjunct term plain/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ws V0 V2) (= V2 (|.| (|91|) (|.| (|93|) V1))))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(plain V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (ops_below_comma V3) (= V4 V1)) (|,| (ws V4 V5) (|,| (= V5 (|.| (|91|) V6)) (|,| (args V3 V7 V6 V8) (|,| (ws V8 V9) (|;| (|,| (= V9 (|.| (|124|) V10)) (|,| (term V3 V11 V10 V12) (|,| (= V12 (|.| (|93|) V13)) (|,| (listify_list V11 V0 V7) (= V2 V13))))) (|,| (= V9 (|.| (|93|) V14)) (|,| (listify_list V0 V7) (= V2 V14)))))))))) height) query) stack height)) (failure stack height))))))

(define-relation ((args/4 args 4 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(args V0 (|.| V1 V2) V3 V4)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (term V0 V1 V3 V5) (|,| (ws V5 V6) (|;| (|->| (|,| (= V6 (|.| (|44|) V7)) (|,| (ws V7 V8) (args V0 V2 V8 V9))) (= V9 V4)) (|,| (= V2 (|[]|)) (= V4 V6)))))) height) query) stack height)) (failure stack height))))

(define-relation ((listify_list/2 listify_list 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(listify_list (compound (|[]|) (|[]|)) (|[]|))))) (continue query (cons (make-choicepoint (cons (make-conjunct term listify_list/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(listify_list (compound (|.|) (|.| V0 (|.| V1 (|[]|)))) (|.| V0 V2))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(listify_list V1 V2)) height) query) stack height)) (failure stack height))))))

(define-relation ((listify_list/3 listify_list 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(listify_list V0 V0 (|[]|))))) (continue query (cons (make-choicepoint (cons (make-conjunct term listify_list/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(listify_list V0 (compound (|.|) (|.| V1 (|.| V2 (|[]|)))) (|.| V1 V3))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(listify_list V0 V2 V3)) height) query) stack height)) (failure stack height))))))

(define-relation ((term/4 term 4 8) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((8 clause-8) (<- bindings (unify (list term) (list (thaw '(term (|.| (|,| (xfx) V0) V1) V2 V3 V4)))) (continue (cons (term->conjunct (thaw '(|,| (term V1 V5 V3 V6) (|;| (|,| (oper V7 V0 V6 V8) (|,| (term V1 V9 V8 V10) (|,| (= V2 (compound V7 (|.| V5 (|.| V9 (|[]|))))) (= V4 V10)))) (|,| (= V2 V5) (= V4 V6))))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 8 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-7))) ((7 clause-7) (<- bindings (unify (list term) (list (thaw '(term (|.| (|,| (xfy) V0) V1) V2 V3 V4)))) (if (= choice 8) (continue (cons (term->conjunct (thaw '(|,| (term V1 V5 V3 V6) (|;| (|,| (oper V7 V0 V6 V8) (|,| (term (|.| (|,| (xfy) V0) V1) V9 V8 V10) (|,| (= V2 (compound V7 (|.| V5 (|.| V9 (|[]|))))) (= V4 V10)))) (|,| (= V2 V5) (= V4 V6))))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 7 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (term V1 V5 V3 V6) (|;| (|,| (oper V7 V0 V6 V8) (|,| (term (|.| (|,| (xfy) V0) V1) V9 V8 V10) (|,| (= V2 (compound V7 (|.| V5 (|.| V9 (|[]|))))) (= V4 V10)))) (|,| (= V2 V5) (= V4 V6))))) (|-| height 1)) query) stack height))) (clause-6))) ((6 clause-6) (<- bindings (unify (list term) (list (thaw '(term (|.| (|,| (yfx) V0) V1) V2 V3 V4)))) (if (= choice 8) (continue (cons (term->conjunct (thaw '(|,| (seperated V0 V1 V5 V3 V6) (|,| (rollup V5 V2) (= V4 V6)))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 6 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (seperated V0 V1 V5 V3 V6) (|,| (rollup V5 V2) (= V4 V6)))) (|-| height 1)) query) stack height))) (clause-5))) ((5 clause-5) (<- bindings (unify (list term) (list (thaw '(term (|.| (|,| (fx) V0) V1) V2 V3 V4)))) (if (= choice 8) (continue (cons (term->conjunct (thaw '(|;| (|,| (oper V5 V0 V3 V6) (|,| (ws1 V6 V7) (|,| (term V1 V8 V7 V9) (|,| (= V2 (compound V5 (|.| V8 (|[]|)))) (= V4 V9))))) (term V1 V2 V3 V4))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 5 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|;| (|,| (oper V5 V0 V3 V6) (|,| (ws1 V6 V7) (|,| (term V1 V8 V7 V9) (|,| (= V2 (compound V5 (|.| V8 (|[]|)))) (= V4 V9))))) (term V1 V2 V3 V4))) (|-| height 1)) query) stack height))) (clause-4))) ((4 clause-4) (<- bindings (unify (list term) (list (thaw '(term (|.| (|,| (fy) V0) V1) V2 V3 V4)))) (if (= choice 8) (continue (cons (term->conjunct (thaw '(|;| (|,| (oper V5 V0 V3 V6) (|,| (ws1 V6 V7) (|,| (term (|.| (|,| (fy) V0) V1) V8 V7 V9) (|,| (= V2 (compound V5 (|.| V8 (|[]|)))) (= V4 V9))))) (term V1 V2 V3 V4))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 4 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|;| (|,| (oper V5 V0 V3 V6) (|,| (ws1 V6 V7) (|,| (term (|.| (|,| (fy) V0) V1) V8 V7 V9) (|,| (= V2 (compound V5 (|.| V8 (|[]|)))) (= V4 V9))))) (term V1 V2 V3 V4))) (|-| height 1)) query) stack height))) (clause-3))) ((3 clause-3) (<- bindings (unify (list term) (list (thaw '(term (|[]|) V0 V1 V2)))) (if (= choice 8) (continue (cons (term->conjunct (thaw '(|,| (ws V1 V3) (|,| (= V3 (|.| (|40|) V4)) (|,| (|,| (ops V5) (= V6 V4)) (|,| (term V5 V0 V6 V7) (|,| (ws V7 V8) (= V8 (|.| (|41|) V2)))))))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 3 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ws V1 V3) (|,| (= V3 (|.| (|40|) V4)) (|,| (|,| (ops V5) (= V6 V4)) (|,| (term V5 V0 V6 V7) (|,| (ws V7 V8) (= V8 (|.| (|41|) V2)))))))) (|-| height 1)) query) stack height))) (clause-2))) ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(term (|[]|) (compound (|{}|) V0) V1 V2)))) (if (= choice 8) (continue (cons (term->conjunct (thaw '(|,| (ws V1 V3) (|,| (= V3 (|.| (|123|) V4)) (|,| (|,| (ops V5) (= V6 V4)) (|,| (term V5 V0 V6 V7) (|,| (ws V7 V8) (= V8 (|.| (|125|) V2)))))))) height) query) (cons (make-choicepoint (cons (make-conjunct term term/4 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ws V1 V3) (|,| (= V3 (|.| (|123|) V4)) (|,| (|,| (ops V5) (= V6 V4)) (|,| (term V5 V0 V6 V7) (|,| (ws V7 V8) (= V8 (|.| (|125|) V2)))))))) (|-| height 1)) query) stack height))) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(term (|[]|) V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(plain V0 V1 V2)) height) query) stack height)) (failure stack height))))))

(define-relation ((term/3 term 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(term V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (|,| (ops V3) (= V4 V1)) (|,| (term V3 V0 V4 V5) (= V5 (|.| (|46|) V2))))) height) query) stack height)) (failure stack height))))

(define-relation ((oper/4 oper 4 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(oper V0 V1 V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ws V2 V4) (|,| (member (|,| V0 V5) V1) (append V5 V3 V4)))) height) query) stack height)) (failure stack height))))

(define-relation ((seperated/5 seperated 5 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(seperated V0 V1 V2 V3 V4)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (term V1 V5 V3 V6) (|;| (|,| (oper V7 V0 V6 V8) (|,| (seperated V0 V1 V9 V8 V10) (|,| (= V2 (|.| V5 (|.| V7 V9))) (= V4 V10)))) (|,| (= V2 (|.| V5 (|[]|))) (= V4 V6))))) height) query) stack height)) (failure stack height))))

(define-relation ((rollup/2 rollup 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(rollup (|.| V0 (|[]|)) V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term rollup/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(rollup (|.| V0 (|.| V1 (|.| V2 V3))) V4)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(rollup (|.| (compound V1 (|.| V0 (|.| V2 (|[]|)))) V3) V4)) height) query) stack height)) (failure stack height))))))

(define-relation ((get_file_contents/2 get_file_contents 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(get_file_contents V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (open V0 (read) V2) (|,| (get_contents V2 V1) (close V2)))) height) query) stack height)) (failure stack height))))

(define-relation ((get_contents/2 get_contents 2 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(get_contents V0 (|[]|))))) (continue (cons (term->conjunct (thaw '(|,| (at_end_of_stream V0) (!))) height) query) (cons (make-choicepoint (cons (make-conjunct term get_contents/2 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(get_contents V0 (|.| V1 V2))))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (get_code V0 V1) (get_contents V0 V2))) height) query) stack height)) (failure stack height))))))

(define-relation ((ir2pl/3 ir2pl 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(ir2pl (variable V0) V1 V2)))) (continue (cons (term->conjunct (thaw '(|,| (member (|-->| V0 V1) V2) (!))) height) query) (cons (make-choicepoint (cons (make-conjunct term ir2pl/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(ir2pl (compound V0 V1) V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ir2pls V1 V4 V3) (=.. V2 (|.| V0 V4)))) height) query) stack height)) (failure stack height))))))

(define-relation ((ir2pls/3 ir2pls 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(ir2pls (|[]|) (|[]|) V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term ir2pls/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(ir2pls (|.| V0 V1) (|.| V2 V3) V4)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ir2pl V0 V2 V4) (ir2pls V1 V3 V4))) height) query) stack height)) (failure stack height))))))

(define-relation ((parse_terms/3 parse_terms 3 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(parse_terms V0 V1 V2)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|;| (|->| (term V3 V1 V4) (|,| (parse_terms V5 V4 V6) (|,| (|,| (ir2pl V3 V7 V8) (= V0 (|.| V7 V5))) (= V2 V6)))) (|,| (= V0 (|[]|)) (= V2 V1)))) height) query) stack height)) (failure stack height))))

(define-relation ((ir2pl/3 ir2pl 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(ir2pl (variable V0) V1 V2)))) (continue (cons (term->conjunct (thaw '(|,| (member (|-->| V0 V1) V2) (!))) height) query) (cons (make-choicepoint (cons (make-conjunct term ir2pl/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(ir2pl (compound V0 V1) V2 V3)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ir2pls V1 V4 V3) (=.. V2 (|.| V0 V4)))) height) query) stack height)) (failure stack height))))))

(define-relation ((ir2pls/3 ir2pls 3 2) term query stack height choice cut-index) (let ((thaw (term-thawer))) (clauses choice ((2 clause-2) (<- bindings (unify (list term) (list (thaw '(ir2pls (|[]|) (|[]|) V0)))) (continue query (cons (make-choicepoint (cons (make-conjunct term ir2pls/3 2 (|+| 1 height)) query) bindings) stack) (|+| 1 height)) (clause-1))) ((1 clause-1) (<- bindings (unify (list term) (list (thaw '(ir2pls (|.| V0 V1) (|.| V2 V3) V4)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (ir2pl V0 V2 V4) (ir2pls V1 V3 V4))) height) query) stack height)) (failure stack height))))))

(define-relation ((parse_string/2 parse_string 2 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(parse_string V0 V1)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (term V2 V0 V3) (ir2pl V2 V1 V4))) height) query) stack height)) (failure stack height))))

(define-relation ((main/0 main 0 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (continue (cons (term->conjunct (thaw '(|,| (write_atom (|?- |)) (|,| (read_line V0) (|,| (parse_string V0 V1) (|;| (|,| (execute_term V1) (|,| (!) (main))) (|,| (write_atom (no.)) (|,| (nl) (main)))))))) height) query) stack height)))

(define-relation ((execute_term/1 execute_term 1 1) term query stack height choice cut-index) (let ((thaw (term-thawer))) (<- bindings (unify (list term) (list (thaw '(execute_term V0)))) (begin (stack-add-bindings! stack bindings) (continue (cons (term->conjunct (thaw '(|,| (call V0) (|,| (write_term V0) (|,| (read_line V1) (|,| (|\\=| V1 (|.| (|59|) (|[]|))) (!)))))) height) query) stack height)) (failure stack height))))

(define (main) (interact '(main)))

(main)

