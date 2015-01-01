(define +base+ (void))
(define +choicepoints+ (void))

(define (make-choicepoint query clauses stack) (list query clauses stack '()))
(define (choicepoint-query choicepoint) (car choicepoint))
(define (choicepoint-clauses? choicepoint) (cadr choicepoint))
(define (choicepoint-pop-clause choicepoint)
  (let ((clause ((car (choicepoint-clauses? choicepoint)))))
    (set-car! (cdr choicepoint) (cdr (choicepoint-clauses? choicepoint)))
    clause))
(define (choicepoint-stack choicepoint) (caddr choicepoint))
(define (choicepoint-bindings choicepoint) (cadddr choicepoint))
(define (choicepoint-undo-bindings choicepoint)
  (map unbind! (choicepoint-bindings choicepoint))
  (set-car! (cdddr choicepoint) '()))
(define (choicepoint-add-bindings choicepoint bindings)
  (set-car! (cdddr choicepoint) (append bindings (choicepoint-bindings choicepoint))))

(define (current-choicepoint) (car +choicepoints+))
(define (current-choicepoint-stack) +choicepoints+)
(define (replace-current-choicepoint choicepoint)
  (set! +choicepoints+ (cons choicepoint (cdr +choicepoints+))))

(define (execute-current-choicepoint)
  (if (null? +choicepoints+)
      #f
      (let ((choicepoint (current-choicepoint)))
        (choicepoint-undo-bindings choicepoint)
        (cond ((choicepoint-clauses? choicepoint)
               => (lambda (clauses)
                    (if (null? clauses)
                        (if (null? (cdr +choicepoints+))
                            #f
                            (begin
                              (set! +choicepoints+ (cdr +choicepoints+))
                              (failure)))
                        (let* ((clause (choicepoint-pop-clause choicepoint))
                               (unification (unify (list (equate (choicepoint-query choicepoint)
                                                                 (clause-head clause))))))
                          (if unification
                              (begin
                                (choicepoint-add-bindings choicepoint (map equation-lhs unification))
                                (prove (clause-body clause) (choicepoint-stack choicepoint)))
                              (failure))))))
              (else (prove (choicepoint-query choicepoint)
                           (choicepoint-stack choicepoint)))))))

(define (success) #t)
(define (failure)
  (if (null? +choicepoints+)
      #f
      (execute-current-choicepoint)))

(define (setup base query)
  (set! +base+ base)
  (set! +choicepoints+ '())
  (push! (make-choicepoint query #f +choicepoints+) +choicepoints+))

(define (prove query stack)
  (let ((query (dereference query)))
    (cond ((not (compound? query))
           (failure))
          
          ((equal? 'true/0 (compound-functor query))
           (success))
          
          ((equal? '!/0 (compound-functor query))
           (set! +choicepoints+ stack)
           (success))
          
          ((equal? 'and/2 (compound-functor query))
           (push! (make-choicepoint (car (compound-parameters query)) #f stack) +choicepoints+)
           (if (failure)
               (begin
                 (push! (make-choicepoint (cadr (compound-parameters query)) #f stack) +choicepoints+)
                 (failure))
               #f))
          
          (else
           (replace-current-choicepoint (make-choicepoint query (lookup +base+ query) +choicepoints+))
           (failure)))))


(define (interact query all?)
  (let ((query ((make-term-thawer) query)))
    (setup (consult "test.spl") query)
    (let loop ()
      (if (failure)
          (cons (if all? ((make-term-freezer) query) query) (if all? (loop) (lambda () (loop))))
          (if all? '() #f)))))
