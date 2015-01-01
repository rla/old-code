;; For mzscheme:
;; (require (lib "69.ss" "srfi"))

;; For SISC:
;; (require-library 'sisc/libs/srfi/srfi-69)
;; (import srfi-69)

;; For Chicken:
;; csc prolog.scm -require-extension syntactic-closures

;; For mit-scheme:
;; ;; works as is


;; Utilites

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

(define (any predicate list)
  (if (null? list)
      #f
      (or (predicate (car list))
          (any predicate (cdr list)))))

;;(define identity (lambda (i) i))

(define (fold f z l)
  (if (null? l)
      z
      (f (car l) (fold f z (cdr l)))))


;;;; This code is in 4 parts:
;;;; * Term manipulation
;;;; * Unification
;;;; * Clause database handling
;;;; * Interpretation

;;;; Term manipulation
;; Concrete syntax is s-expressions rather than strings of Prolog text for simplicity,
;; one might implement Prolog syntax in Prolog after having this interpreter finished.
;; The abstract syntax is lists representing compounds and 1-vectors representing
;; variables.

(define (make-variable) (unbind! (make-vector 1)))
(define (unbind! variable) (bind! variable variable))
(define (bind! variable value) (vector-set! variable 0 value)
  variable)
(define variable? vector?)
(define (dereference variable)
  (if (variable? variable)
      (let ((value (vector-ref variable 0)))
        (if (eq? variable value)
            value
            (dereference value)))
      variable))


(define (make-compound name args) (cons name (cons (length args) args)))
(define compound-name car)
(define compound-arity cadr)
(define compound-args cddr)
(define (compound-functor compound)
  (string->symbol (string-append (symbol->string (compound-name compound))
                                 "/"
                                 (number->string (compound-arity compound)))))
(define compound? pair?)

(define (term-thawer)
  (let ((names '()))
    (letrec ((fresh (lambda (name)
                      (cond ((assoc name names) => cdr)
                            (else
                             (cdr (push! names (cons name (make-variable))))))))
             (thaw (lambda (term)
                       (if (symbol? term)
                           (fresh term)
                           (make-compound (car term) (map thaw (cdr term)))))))
      thaw)))

(define (term-freezer)
  (let ((counter 0)
        (variables '()))
    (letrec ((gensym (lambda ()
                       (set! counter (+ counter 1))
                       (string->symbol (string-append "v" (number->string counter)))))
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


;;;; Unification
;; Occurs check stops a possible infinite loop with cyclic unficiations
;; Unification returns #f on failure or a list of previously unbound variables that have been
;; bound on success

(define occurs?
  (lambda (variable)
    (lambda (term)
      (let ((term (dereference term)))
        (cond ((variable? term) (eq? variable term))
              (else (any (occurs? variable) (compound-args term))))))))

 (define (unify pairs)
  (define (cons/fail car cdr?)
    (if cdr?
        (cons car cdr?)
        (begin
          (unbind! car)
          #f)))
  (if (null? pairs)
      '()
      (let ((lhs (dereference (caar pairs)))
            (rhs (dereference (cdar pairs))))
        (cond ((and (compound? lhs) (compound? rhs))
               (if (and (equal? (compound-name lhs) (compound-name rhs))
                        (= (compound-arity lhs) (compound-arity rhs)))
                   (unify
                    (append (map cons (compound-args lhs) (compound-args rhs))
                            (cdr pairs)))
                   #f))
              ((not (variable? lhs))
               (unify (cons (cons rhs lhs) (cdr pairs))))
              ((eq? lhs rhs)
               (unify (cdr pairs)))
              (((occurs? lhs) rhs)
               #f)
              (else
               (bind! lhs rhs)
               (cons/fail lhs (unify (cdr pairs))))))))

;;(define (test-unify left right)
;;  (let* ((thawer (term-thawer))
;;         (left* (thawer left))
;;         (right* (thawer right)))
;;    (if (unify (list (cons left* right*)))
;;        ((term-freezer) left*)
;;        #f)))


;;;; Clause database handling
;; 

(define (read-file file)
  (call-with-input-file file
    (lambda (port)
      (let loop ()
        (let ((object (read port)))
          (if (eof-object? object)
              '()
              (cons object (loop))))))))

(define (consult file)
  (let ((database (make-hash-table)))
    (for-each (lambda (rule)
                (let ((compiled-rule (compile-rule rule)))
                  (hash-table-update!/default database
                    (car compiled-rule)
                    (lambda (entry)
                      (cond ((assoc (cadr compiled-rule) entry)
                             => (lambda (association)
                                  (set-cdr! association 
                                            (append (cdr association)
                                                    (cddr compiled-rule)))
                                  entry))
                            (else (cons (cons (cadr compiled-rule)
                                              (cddr compiled-rule))
                                        entry))))
                    '())))
              (read-file file))
    database))

(define (compile-rule rule)
  (let ((rule-head (cadr rule))
        (rule-body (cddr rule)))
    (cond ((null? rule-body)
           (set! rule-body '(true)))
          ((null? (cdr rule-body))
           (set! rule-body (car rule-body)))
          (else (set! rule-body (fold (lambda (x ys) `(and ,x ,ys))
                                      (car (reverse rule-body))
                                      (reverse (cdr (reverse rule-body)))))))
    (list (car rule-head)
          (length (cdr rule-head))
          (lambda ()
            (let ((thawer (term-thawer)))
              (cons (thawer rule-head)
                    (thawer rule-body)))))))

(define (clause database head)
  (cond ((assoc (compound-arity head)
                (hash-table-ref/default database (compound-name head) '())) => cdr)
        (else '())))


;;;; Interpretation

(define +database+ #f)
(define +choicepoints+ #f)

(define (push-choicepoint choices query)
  (push! +choicepoints+ (list choices query '())))
(define choicepoint-choices car)
(define (pop-choice! choicepoint)
  (let ((choice (car (choicepoint-choices choicepoint))))
    (set-car! choicepoint (cdr (choicepoint-choices choicepoint)))
    choice))
(define (pop-all-choices! choicepoint)
  (if choicepoint
      (set-car! choicepoint '())
      (void)))
(define choicepoint-query cadr)
(define (current-choicepoint)
  (if (null? +choicepoints+)
      #f
      (car +choicepoints+)))
(define (choicepoint-undo-bindings! choicepoint)
  (for-each unbind! (caddr choicepoint))
  (set-car! (cddr choicepoint) '()))
(define (choicepoint-remember-bindings! bindings choicepoint)
  (set-car! (cddr choicepoint) (append (caddr choicepoint) bindings)))
(define (choicepoint-bindings choicepoint)
  (caddr choicepoint))
(define (count-choicepoints)
  (length +choicepoints+))

(define (prove query)
  (if (null? query)
      (success)
      (let ((query-head (dereference (caar query))))
        (if (variable? query-head)
            (fail)
            (case (compound-functor query-head)
              ((true/0)
               (prove (cdr query)))
              ((debug/0)
               (display 'choicepoints--) (newline)
               (for-each (lambda (p)
                           (display p) (newline))
                         +choicepoints+)
               (newline)
               (display 'query--) (newline)
               (display query) (newline)
               (display '------) (newline)
               (error 'done))
              ((number/1)
               (if (number? (car (compound-args query-head)))
                   (prove (cdr query))
                   (fail)))
              ((%+/3)
               (let* ((a (compound-name (dereference (car (compound-args query-head)))))
                      (b (compound-name (dereference (cadr (compound-args query-head)))))
                      (c (make-compound (+ a b) '())))
                 (let ((u (unify (list (cons c (caddr (compound-args query-head)))))))
                   (if u
                       (begin
                         (if (current-choicepoint)
                             (choicepoint-remember-bindings! u (current-choicepoint))
                             (void))
                         (prove (cdr query)))
                       (fail)))))
              ((!/0)
               ;; cut to which choice point?
               ;; merge all the bindings together
               ;; remove all choices
               ;; set the choicepoitn query to my query
               ;; prove cdr
               (let ((cut-to (cdar query)))
                 (let pop ((pushdowns-needed (- (count-choicepoints) cut-to)))
                   (cond ((null? +choicepoints+)
                          (prove (cdr query)))
                         ((zero? pushdowns-needed)
                          (let ((point (pop! +choicepoints+)))
                            (push! +choicepoints+ (list '() query (choicepoint-bindings point))))
                          (prove (cdr query)))
                         (else
                          (let ((bindings (pop! +choicepoints+)))
                            (choicepoint-remember-bindings! (current-choicepoint)
                                                            bindings))
                          (pop (- pushdowns-needed 1)))))))
              ((and/2)
               (prove `(,(cons (car (compound-args query-head)) (cdar query))
                        ,(cons (cadr (compound-args query-head)) (cdar query))
                        . ,(cdr query))))
              (else
               (push-choicepoint (clause +database+ query-head) query)
               (fail)))))))

(define (success) #t)

(define (fail)
  (cond ((null? +choicepoints+)
         #f)
        ((null? (choicepoint-choices (current-choicepoint)))
         (choicepoint-undo-bindings! (current-choicepoint))
         (pop! +choicepoints+)
         (fail))
        (else
         (choicepoint-undo-bindings! (current-choicepoint))
         (let* ((choice ((pop-choice! (current-choicepoint))))
                (query (choicepoint-query (current-choicepoint))))
           (let ((unification (unify (list (cons (caar query) (car choice))))))
             (if unification
                 (begin
                   (choicepoint-remember-bindings! unification (current-choicepoint))
                   (prove (cons (cons (cdr choice) (count-choicepoints)) (cdr query))))
                 (fail)))))))


;; testing code:

(define (run n query)
  (let ((query* ((term-thawer) query)))
    (set! +choicepoints+ '())
    (if (prove (list (cons query* (count-choicepoints))))
        (let loop ((n n))
          (if (zero? n)
              #t
              (begin
                (display ((term-freezer) query*))
                (newline)
                (if (fail)
                    (loop (- n 1))
                    #f))))
        #f)))

(define (main)
  (set! +database+ (consult "prelude.spl"))
  (run 1 '(saturn+ x)))

(main)

;; ;; Test.spl
;; (fact (= x x))
;;
;; (fact (flip (heads)))
;; (fact (flip (tails)))
;;
;; (to-derive (member x (cons x xs)))
;; (to-derive (member x (cons e xs))
;;            (member x xs))
;;
;; (to-derive (append (nil) ys ys))
;; (to-derive (append (cons x xs) ys (cons x zs))
;;            (append xs ys zs))
;;
;; (to-derive (select e (cons e es) es))
;; (to-derive (select e (cons x es) (cons x fs))
;;            (select e es fs))

;; (set! +database+ (consult "prelude.spl"))

;; > (run 5 '(append p q (cons (a) (cons (b) (cons (c) (nil))))))
;; (append (nil) (cons (a) (cons (b) (cons (c) (nil)))) (cons (a) (cons (b) (cons (c) (nil)))))
;; (append (cons (a) (nil)) (cons (b) (cons (c) (nil))) (cons (a) (cons (b) (cons (c) (nil)))))
;; (append (cons (a) (cons (b) (nil))) (cons (c) (nil)) (cons (a) (cons (b) (cons (c) (nil)))))
;; (append (cons (a) (cons (b) (cons (c) (nil)))) (nil) (cons (a) (cons (b) (cons (c) (nil)))))
;; #f






