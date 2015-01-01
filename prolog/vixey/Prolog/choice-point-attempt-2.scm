(define (make-choicepoint query clauses stack continuation)
  (list
   query ;; what to prove
   '() ;; bindings that must be undone when backtracking
   clauses ;; either #f (which means try prove) or a list of clauses
   stack ;; something to do with cut.....?
   continuation ;; the entire rest of the program
   ))

(define choicepoint-query car)
(define choicepoint-bindings cadr)
(define choicepoint-clauses caddr)
(define choicepoint-stack cadddr)
(define (choicepoint-continuation choicepoint) (cadddr (cdr choicepoint)))
(define-syntax set-choicepoint-bindings!
  (syntax-rules ()
    ((set-choicepoint-bindings! <choicepoint> <bindings>)
     (set-car! (cdr <choicepoint>) <bindings>))))
(define-syntax set-choicepoint-clauses!
  (syntax-rules ()
    ((set-choicepoint-clauses! <choicepoint> <clauses>)
     (set-car! (cddr <choicepoint>) <clauses>))))

(define (choicepoint-pop-clause! choicepoint)
  (let* ((clauses (choicepoint-clauses choicepoint))
         (clause (car clauses)))
    (set-choicepoint-clauses! choicepoint (cdr clauses))
    (clause)))

(define (choicepoint-undo-bindings choicepoint)
  (map unbind! (choicepoint-bindings choicepoint))
  (set-choicepoint-bindings! choicepoint '()))
(define (choicepoint-add-bindings choicepoint bindings)
  (set-choicepoint-bindings! choicepoint (append bindings (choicepoint-bindings choicepoint))))


(define +choicepoints+ '())

(define (current-choicepoint) (car +choicepoints+))
(define (current-choicepoint-stack) +choicepoints+)
(define (pop-choicepoint!)
  (if (null? +choicepoints+) (void) (set! +choicepoints+ (cdr +choicepoints+))))


;; Interpreters

(define +base+ #f)

(define (success) #t)
(define (failure)
  (if (null? +choicepoints+)
      #f
      (execute-current-choicepoint)))

(define (setup base query)
  (set! +base+ base)
  (set! +choicepoints+ '())
  (push! (make-choicepoint query #f +choicepoints+ #t) +choicepoints+))

(define (execute-current-choicepoint)
  (if (null? +choicepoints+)
      #f
      (let ((choicepoint (current-choicepoint)))
        (cond ((choicepoint-clauses choicepoint)
               => (lambda (clauses)
                    (choicepoint-undo-bindings choicepoint)
                    (cond ((null? clauses)
                           (pop-choicepoint!)
                           (failure))
                          (else
                           (let ((clause (choicepoint-pop-clause! choicepoint)))
                             (cond ((unify (list (equate (choicepoint-query choicepoint)
                                                         (clause-head clause))))
                                    => (lambda (unification)
                                         (choicepoint-add-bindings choicepoint (map equation-lhs unification))
                                         (push! (make-choicepoint (clause-body clause) #f
                                                                  (choicepoint-stack choicepoint)
                                                                  (choicepoint-continuation choicepoint))
                                                +choicepoints+)
                                         (execute-current-choicepoint)))
                                   (else (failure))))))))
              (else (prove (choicepoint-query choicepoint)
                           (choicepoint-stack choicepoint)
                           (choicepoint-continuation choicepoint)))))))

(define (prove query stack continuation)
  (and
   (let ((query (dereference query)))
     (cond ((equal? 'true/0 (compound-functor query))
            (pop-choicepoint!)
            (success))
           
           ((equal? '!/0 (compound-functor query))
            (pop-choicepoint!)
            (set! +choicepoints+ stack)
            (success))
           
           ((equal? 'and/2 (compound-functor query))
            (push! (make-choicepoint (car (compound-parameters query)) #f stack
                                     (make-choicepoint (cadr (compound-parameters query)) #f stack #t))
                   +choicepoints+)
            (execute-current-choicepoint))
           
           (else
            (set-choicepoint-clauses! (current-choicepoint) (lookup +base+ query))
            (execute-current-choicepoint))))
   (cond ((eq? #t continuation) #t)
         (else (push! continuation +choicepoints+)
               (execute-current-choicepoint)))))


(define (interact query all?)
  (let ((query ((make-term-thawer) query)))
    (setup (consult "test.spl") query)
    (let loop ()
      (sleep 0.1)
      (if (failure)
          (cons
           (if all?
               (let ((t ((make-term-freezer) query)))
                 (display t)
                 (display " ") (display +choicepoints+)
                 (newline)
                 t)
               query)
           (if all? (loop) (lambda () (loop))))
          (if all? '() #f)))))
