
(define (make-choicepoint query bindings clauses stack continuation)
  (list
   query ;; what to prove
   bindings ;; must be undone when backtracking
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
  (if (null? +choicepoints+)
      (void)
      (begin
        (map unbind! (choicepoint-bindings (current-choicepoint)))
        (set! +choicepoints+ (cdr +choicepoints+)))))


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
  (push! (make-choicepoint query '() #f +choicepoints+ #f) +choicepoints+))

(define (execute-current-choicepoint)
  (cond ((null? +choicepoints+)
         (failure))
        ((choicepoint-clauses (current-choicepoint))
         => (lambda (clauses)
              (cond ((null? clauses)
                     (pop-choicepoint!)
                     (execute-current-choicepoint))
                    (else
                     (let* ((choicepoint (current-choicepoint))
                            (clause (choicepoint-pop-clause! choicepoint))
                            (unification (unify (list (equate (choicepoint-query choicepoint)
                                                              (clause-head clause))))))
                       (if unification
                           (begin (push! (make-choicepoint (clause-body clause)
                                                           (map equation-lhs unification)
                                                           #f
                                                           +choicepoints+
                                                           #f)
                                         +choicepoints+)
                                  (execute-current-choicepoint))
                           (failure)))))))
        ((compound-functor (dereference (choicepoint-query (current-choicepoint))))
         => (lambda (functor)
              (case functor
                ((true/0)
                 (let ((continuation (choicepoint-continuation (current-choicepoint))))
                   (pop-choicepoint!)
                   (cond (continuation
                          (push! continuation +choicepoints+)
                          (execute-current-choicepoint))
                         (else (success)))))
                ((!/0)
                 (set! +choicepoints+ (choicepoint-stack (current-choicpoint)))
                 (success))
                ;; ((and/2) ...)
                (else
                 (set-choicepoint-clauses!
                  (current-choicepoint)
                  (lookup +base+ (choicepoint-query (current-choicepoint))))))))))

(define (interact base query)
  (let ((query ((make-term-thawer) query)))
    (setup base query)
    (let loop ()
      (cond ((failure)
             (display ((make-term-freezer) query)) (newline)
             (sleep 0.2)
             (loop))))))



