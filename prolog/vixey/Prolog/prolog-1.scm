;; Prolog interpreter in Scheme - Version 0

;; Can be compiled with chicken 3.0.0:
;; % csc prolog.scm -require-extension syntactic-closures
;; also known to work in DrScheme 372 and SISC 1.16.6


;; The following translates Prolog terms into the s-expression syntax

;; %% translates Prolog terms into an s-expression Prolog dialect
;;
;; flatten([], []).
;; flatten([X|XS], Flat) :- flatten(XS, FS), append(X, FS, Flat).
;;
;; flatten([], _, []).
;; flatten([X], _, X).
;; flatten([X,Y|YS], Spacer, Flat) :- flatten([Y|YS], Spacer, FS), append(X, [Spacer|FS], Flat).
;;
;;
;; get_file_terms(Filename, Terms) :-
;;   open(Filename, read, Fd),
;;   read_all_terms(Fd, Terms),
;;   close(Fd).
;;
;; read_all_terms(Fd, List) :-
;;   read(Fd, Term),
;;   ( Term = end_of_file, List = [], !
;;   ; List = [Term|Rest], read_all_terms(Fd, Rest)
;;   ).
;;
;;
;; transform((Head :- Body), TermT) :- !,
;;   term_variables((Head :- Body), Vars),
;;   numbervars(Vars, 0, _, [functor_name('$VAR')]),
;;   transform(Vars, (Head :- Body), TermT).
;; transform(Term, TermT) :-
;;   term_variables(Term, Vars),
;;   numbervars(Vars, 0, _, [functor_name('$VAR')]),
;;   transform(Vars, fact(Term), TermT).
;;
;; transform(_,        [],   atom(nil)) :- !.
;; transform(_,    Atomic,   atom(Atomic))       :- atomic(Atomic), !.
;; transform(Vars, Variable, variable(Variable)) :- member(Variable, Vars), !.
;; transform(Vars, Compound, compound([FunctorT|ParametersT])) :-
;;   Compound =.. [Functor|Parameters],
;;   transform_functor(Functor, FunctorT), !,
;;   maplist(transform(Vars), Parameters, ParametersT).
;;
;; transform_functor(':-', 'to-derive').
;; transform_functor('.', cons).
;; transform_functor(',', and).
;; transform_functor(';', or).
;; transform_functor(Else, Else).
;;
;;
;; sexpify(atom(Atomic)) --> ['''', Atomic].
;; sexpify(variable('$VAR'(Variable))) --> ['V', Variable].
;; sexpify(compound([Functor|Parameters])) -->
;;   { maplist(sexpify, Parameters, SexpParameters) },
;;   { flatten(SexpParameters, ' ', CattedSexpParameters), ! },
;;   ['(',Functor,' '], CattedSexpParameters, [')'].
;;
;; sexpify(T, S) :- sexpify(T, S, []).
;;
;;
;; compile(Term, CompiledTerm) :-
;;   transform(Term, TermT),
;;   sexpify(TermT, SexpTerm),
;;   concat_atom(SexpTerm, CompiledTerm).
;;
;; compile_file(Filename, Compiled) :-
;;   get_file_terms(Filename, Terms),
;;   maplist(compile, Terms, CompiledTerms),
;;   concat_atom(CompiledTerms, '\n', Compiled).



;; Utilities

(define (fold f zero list)
  (if (null? list) zero
      (f (car list) (fold f zero (cdr list)))))

(define (filter p list)
  (fold (lambda (head tail)
          (if (p head)
              (cons head tail)
              tail))
        '()
        list))

(define (remove-duplicates list)
  (reverse
   (let loop ((filtered '()) (list list))
     (if (null? list)
         filtered
         (if (member (car list) filtered)
             (loop filtered                   (cdr list))
             (loop (cons (car list) filtered) (cdr list)))))))

(define-syntax push!
  (syntax-rules ()
    ((push! <value> <place>)
     (set! <place> (cons <value> <place>)))))



;; Streams

(define-syntax stream-cons
  (syntax-rules ()
    ((cons-stream x y) (cons x (lambda () y)))))

(define (stream-head stream) (car stream))
(define (stream-tail stream) ((cdr stream)))

(define empty-stream '())
(define empty-stream? null?)

(define (stream-map f stream)
  (if (empty-stream? stream)
      empty-stream
      (stream-cons (f (stream-head stream))
                   (stream-map f (stream-tail stream)))))

(define (stream-append-tail stream tail)
  (if (empty-stream? stream)
      (tail)
      (stream-cons (stream-head stream)
                   (stream-append-tail (stream-tail stream) tail))))

;; Cuttable Streams (useful for the implementation of cut)

(define-syntax cuttable-stream-cons
  (syntax-rules ()
    ((cuttable-stream-cons x y) (cons (cons x #f) (lambda () y)))))

(define-syntax cuttable-stream-cutting-cons
  (syntax-rules ()
    ((cuttable-stream-cutting-cons x y) (cons (cons x #t) (lambda () y)))))

(define (cuttable-stream-head stream) (caar stream))
(define (cuttable-stream-head-cut? stream) (cdar stream))
(define (cuttable-stream-tail stream) ((cdr stream)))

(define (cuttable-stream-map f stream)
  (if (empty-stream? stream)
      empty-stream
      (stream-cons (cons (f (cuttable-stream-head stream))
                         (cuttable-stream-head-cut? stream))
                   (cuttable-stream-map f (cuttable-stream-tail stream)))))

(define (cuttable-stream-append-tail stream tail)
  (let loop ((cut? #f) (stream stream))
    (if (empty-stream? stream)
        (if cut?
            empty-stream
            (tail))
        (stream-cons (cons (cuttable-stream-head stream)
                           (cuttable-stream-head-cut? stream))
                     (loop (or cut? (cuttable-stream-head-cut? stream))
                           (stream-tail stream))))))

(define (cuttable-stream-apply-cut! cut? stream)
  (if cut?
      (cuttable-stream-cutting-cons (cuttable-stream-head stream)
                                    (cuttable-stream-tail stream))
      stream))



;; Abstract and concrete syntax of terms

(define (make-variable name)
  `(variable . ,name))
(define (make-compound name . args)
  `(compound ,name ,(length args) . ,args))

(define (variable? term)
  (equal? 'variable (car term)))
(define (compound? term)
  (equal? 'compound (car term)))

(define (variable-name variable)
  (cdr variable))
(define (compound-functor compound)
  (cadr compound))
(define (compound-arity compound)
  (caddr compound))
(define (compound-parameters compound)
  (cdddr compound))

(define (make-term sexp)
  (cond ((equal? '! sexp) (make-compound '!))
        ((symbol? sexp) (make-variable sexp))
        ((number? sexp) (make-compound sexp))
        ((equal? 'quote (car sexp)) (make-compound (cadr sexp)))
        (else (apply make-compound (car sexp) (map make-term (cdr sexp))))))

(define (display-term term)
  (cond ((variable? term) (variable-name term))
        ((= 0 (compound-arity term))
         (if (or (number? (compound-functor term))
                 (equal? '! (compound-functor term)))
             (compound-functor term)
             `',(compound-functor term)))
        (else `(,(compound-functor term)
                . ,(map display-term (compound-parameters term))))))

(define (variables-in-term term)
  (define (variables-in-term-acc term acc)
    (cond ((variable? term) (cons term acc))
          ((compound? term) (fold variables-in-term-acc acc (compound-parameters term)))))
  (variables-in-term-acc term '()))

(define (fresh-variable variable)
  (make-variable (gensym (symbol->string (variable-name variable)))))

(define (fresh-variables variable count)
  (if (= count 0)
      '()
      (cons (fresh-variable variable) (fresh-variables variable (- count 1)))))



;; Occurs check

(define (occurs? variable term)
  (cond ((variable? term) (equal? variable term))
        ((compound? term) (let loop ((parameters (compound-parameters term)))
                            (and (not (null? parameters))
                                 (or (occurs? variable (car parameters))
                                     (loop (cdr parameters))))))))



;; Substitutions are lists of equations

(define equate cons)
(define equation-lhs car)
(define equation-rhs cdr)



;; Term copying, rewriting in terms, substitutions and performing substitutions on terms

(define (rewrite this that term)
  (cond ((equal? term this) that)
        ((variable? term) term)
        ((compound? term) (apply make-compound
                                 (compound-functor term)
                                 (map (lambda (parameter) (rewrite this that parameter))
                                      (compound-parameters term))))))

(define (substitute this that substitution)
  (fold (lambda (equation substitution)
          (let ((new-equation (equate (rewrite this that (equation-lhs equation))
                                      (rewrite this that (equation-rhs equation)))))
            (if (equal? (equation-lhs new-equation)
                        (equation-rhs new-equation))
                substitution
                (cons new-equation substitution))))
        '()
        substitution))

(define (rewrite-substitution substitution term)
  (fold (lambda (equation term)
          (rewrite (equation-lhs equation) (equation-rhs equation) term))
        term
        substitution))

(define (extract-relevant-substitution variables substitution)
  (filter (lambda (equation) (member (equation-lhs equation) variables)) substitution))

(define (copy-term term)
  (rewrite-substitution
   (map (lambda (variable)
          (equate variable (fresh-variable variable)))
        (remove-duplicates (variables-in-term term)))
   term))



;; Unification

(define (fail? thing) (equal? 'fail thing))

(define (unify mgu equations)
  (if (null? equations) mgu
      (let ((lhs (equation-lhs (car equations)))
            (rhs (equation-rhs (car equations))))
        (cond ((equal? lhs rhs) (unify mgu (cdr equations)))
              ((and (compound? lhs) (compound? rhs))
               (if (and (equal? (compound-functor lhs) (compound-functor rhs))
                        (= (compound-arity lhs) (compound-arity rhs)))
                   (unify mgu (append (map equate
                                           (compound-parameters lhs)
                                           (compound-parameters rhs))
                                      (cdr equations)))
                   'fail))
              ((not (variable? lhs)) (unify mgu (cons (equate rhs lhs) (cdr equations))))
              ((occurs? lhs rhs) 'fail)
              (else (unify (cons (car equations) (substitute lhs rhs mgu))
                           (substitute lhs rhs equations)))))))

(define (unify-terms . terms)
  (unify '() (map equate (reverse (cdr (reverse terms))) (cdr terms))))

(define (merge-substitutions . substitutions)
  (unify '() (apply append substitutions)))



;; Defining and interacting with the program database

(define rule-head car)
(define rule-body cdr)

(define (copy-rule rule)
  (let ((substitution (map (lambda (variable)
                             (equate variable (fresh-variable variable)))
                           (remove-duplicates (append (variables-in-term (rule-head rule))
                                                      (variables-in-term (rule-body rule)))))))
    (cons (rewrite-substitution substitution (rule-head rule))
          (rewrite-substitution substitution (rule-body rule)))))

;; A fact is written:
;;   (to-derive <head>) or
;;   (fact <head>)

;; A derivation is written:
;;   (to-derive <head>
;;              <body>
;;              ...)

;; A fact clause is sugar for (to-derive <head> true)
;; Multiple body clauses are sugar for (and <body> ... (and ... true))

(define (make-rule representation)
  (cons (make-term (cadr representation))
        (fold (lambda (head rest)
                (make-compound 'and (make-term head) rest))
              (make-compound 'true)
              (cddr representation))))

(define (make-database representation)
  (map make-rule representation))

(define clause-substitution       car)
(define clause-substituted-body   cadr)
(define clause-remaining-database caddr)

(define (clause query database)
  ;; Returns 'fail or
  ;;         (list <substitution>
  ;;               <substituted-body>
  ;;               <pointer-to-rest-of-database>) ;; to find more clauses
  (if (null? database)
      'fail
      (if (and (equal? (compound-functor query)
                       (compound-functor (rule-head (car database))))
               (= (compound-arity query)
                  (compound-arity (rule-head (car database)))))
          (let* ((rule (copy-rule (car database)))
                 (head (rule-head rule))
                 (body (rule-body rule))
                 (unification (unify-terms query head)))
            (if (fail? unification)
                (clause query (cdr database))
                (list unification
                      (rewrite-substitution unification body)
                      (cdr database))))
          (clause query (cdr database)))))



;; A first interpreter for pure Prolog (free of cuts)

;; This is a Scheme implementation of the following metacircular Prolog interpreter:

;; prove(true).
;; prove((First, Second)) :- prove(First), prove(Second).
;; prove(Goal) :- clause(Goal, Body), prove(Body).

;; With substitutions and success/failure streams written explicitly

;; (define (prove query database)
;;   (cond ((and (compound? query)
;;               (equal? 'true (compound-functor query))
;;               (= 0 (compound-arity query)))
;;          (stream-cons '() empty-stream))
;;         ((and (compound? query)
;;               (equal? 'and (compound-functor query))
;;               (= 2 (compound-arity query)))
;;          (let ((first-query (car (compound-parameters query)))
;;                (second-query (cadr (compound-parameters query))))
;;            (let loop ((first-results (prove first-query database)))
;;              (if (empty-stream? first-results)
;;                  empty-stream
;;                  (stream-append-tail
;;                   (stream-map
;;                    (lambda (substitution)
;;                      (merge-substitutions substitution (stream-head first-results)))
;;                    (prove (rewrite-substitution (stream-head first-results) second-query) database))
;;                   (lambda () (loop (stream-tail first-results))))))))
;;         (else
;;          (let loop ((clause-database-pointer database))
;;            (let ((current-clause (clause query clause-database-pointer)))
;;              (if (fail? current-clause)
;;                  empty-stream
;;                  (stream-append-tail
;;                   (stream-map
;;                    (lambda (substitution)
;;                      (extract-relevant-substitution
;;                       (variables-in-term query)
;;                       (merge-substitutions substitution (clause-substitution current-clause))))
;;                    (prove (clause-substituted-body current-clause) database))
;;                   (lambda () (loop (clause-remaining-database current-clause))))))))))

;; The same Prolog intepreter but supporting cuts (via cuttable streams) and primitives

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
    ((define-primitive (<name> <bindings> ...) <body> ...)
     (*define-primitive '<name> (length '(<bindings> ...)) (lambda (<bindings> ...) <body> ...)))))

(define (prove query database)
  (cond ((and (compound? query) (primitive? (compound-functor query) (compound-arity query)))
         => (lambda (primitive)
              (apply primitive (compound-parameters query))))
        ((and (compound? query)
              (equal? 'and (compound-functor query))
              (= 2 (compound-arity query)))
         (let ((first-query (car (compound-parameters query)))
               (second-query (cadr (compound-parameters query))))
           (let loop ((first-results (prove first-query database)))
             (if (empty-stream? first-results)
                 empty-stream
                 (cuttable-stream-append-tail
                  (cuttable-stream-map
                   (lambda (substitution)
                     (merge-substitutions substitution (cuttable-stream-head first-results)))
                   (cuttable-stream-apply-cut!
                    (cuttable-stream-head-cut? first-results)
                    (prove (rewrite-substitution (cuttable-stream-head first-results) second-query) database)))
                  (lambda () (loop (cuttable-stream-tail first-results))))))))
        (else
         (let loop ((clause-database-pointer database))
           (let ((current-clause (clause query clause-database-pointer)))
             (if (fail? current-clause)
                 empty-stream
                 (cuttable-stream-append-tail
                  (cuttable-stream-map
                   (lambda (substitution)
                     (extract-relevant-substitution
                      (variables-in-term query)
                      (merge-substitutions substitution (clause-substitution current-clause))))
                   (prove (clause-substituted-body current-clause) database))
                  (lambda () (loop (clause-remaining-database current-clause))))))))))



;; The bulk of the intepreter is now primitives,

(define-primitive (true)
  (cuttable-stream-cons '() empty-stream))

(define-primitive (!)
  (cuttable-stream-cutting-cons '() empty-stream))

(define-primitive (var x)
  (if (variable? x)
      (cuttable-stream-cons '() empty-stream)
      empty-stream))

(define-primitive (nonvar x)
  (if (not (variable? x))
      (cuttable-stream-cons '() empty-stream)
      empty-stream))

(define-primitive (compound x)
  (if (compound? x)
      (cuttable-stream-cons '() empty-stream)
      empty-stream))

(define-primitive (atom x)
  (if (and (compound? x) (= 0 (compound-arity x)) (not (number? (compound-functor x))))
      (cuttable-stream-cons '() empty-stream)
      empty-stream))

(define-primitive (number x)
  (if (and (compound? x) (= 0 (compound-arity x)) (number? (compound-functor x)))
      (cuttable-stream-cons '() empty-stream)
      empty-stream))


;; (define-primitive (functor compound name arity)
;;   ;; TODO
;;   )

(define-primitive (arg n term arg)
  (cond ((variable? term) empty-stream)
        ((and (compound? n) (= 0 (compound-arity n)) (number? (compound-functor n))
              (< (compound-functor n) (compound-arity term)))
         (let ((result (unify-terms (list-ref (compound-parameters term)
                                              (compound-functor n))
                                    arg)))
           (if (fail? result)
               empty-stream
               (cuttable-stream-cons result empty-stream))))
        (else empty-stream)))

;; (define-primitive (=.. term list)
;;   ;; TODO
;;   )

(define-primitive (copy-term term-1 term-2)
  (let* ((copied-term (copy-term term-1))
         (result (unify-terms copied-term term-2)))
    (if (fail? result)
        empty-stream
        (cuttable-stream-cons result empty-stream))))

;; (define-primitive (numbervars term start end)
;;   ;; TODO
;;   )

;; TODO:
;;  clause
;;  asserta assertz
;;  retract abolish
;;  (findall term goal bag) bagof setof

(define-syntax define-binary-primitive
  (syntax-rules ()
    ((define-binary-primitive <name> <operation>)
     (define-primitive (<name> x y place)
       (if (and (compound? x) (= 0 (compound-arity x)) (number? (compound-functor x))
                (compound? y) (= 0 (compound-arity y)) (number? (compound-functor y)))
           (let ((result (make-term (<operation> (compound-functor x) (compound-functor y)))))
             (if (variable? place)
                 (cuttable-stream-cons (list (equate place result)) empty-stream)
                 (if (equal? place result)
                     (cuttable-stream-cons '() empty-stream)
                     empty-stream))))))))

(define-syntax define-unary-primitive
  (syntax-rules ()
    ((define-unary-primitive <name> <operation>)
     (define-primitive (<name> x place)
       (if (and (compound? x) (= 0 (compound-arity x)) (number? (compound-functor x)))
           (let ((result (make-term (<operation> (compound-functor x)))))
             (if (variable? place)
                 (cuttable-stream-cons (list (equate place result)) empty-stream)
                 (if (equal? place result)
                     (cuttable-stream-cons '() empty-stream)
                     empty-stream))))))))

(define-binary-primitive %+ +)
(define-binary-primitive %- -)
(define-binary-primitive %* *)
(define-binary-primitive %** expt)
(define-binary-primitive %/ /)
(define-binary-primitive %mod modulo)
(define-binary-primitive %rem remainder)

(define-unary-primitive %sqrt sqrt)
(define-unary-primitive %sin sin)
(define-unary-primitive %cos cos)
(define-unary-primitive %asin asin)
(define-unary-primitive %acos acos)
(define-unary-primitive %abs abs)
(define-unary-primitive %floor floor)
(define-unary-primitive %round round)
(define-unary-primitive %ceiling ceiling)



;; An interactive interface to a database

(define (interact database)
  (display "?- ")
  (let* ((query (make-term (read))))
    (let loop ((results (prove query database)))
      (cond ((empty-stream? results)
             (display "no")
             (newline)
             (interact database))
            (else
             (map (lambda (equation)
                    (display `(= ,(display-term (equation-lhs equation))
                                 ,(display-term (equation-rhs equation))))
                    (newline))
                  (cuttable-stream-head results))
             (display "more? ")
             (case (read)
               ((more) (loop (cuttable-stream-tail results)))
               (else (interact database))))))))



(define +prolog-db+
 '(;; unification is defined by reflexivity
    (fact (= x x))
    
    ;; disjunction
    (to-derive (or x y) x)
    (to-derive (or x y) y)
    
    (fact (repeat))
    (to-derive (repeat) (repeat))
    
    (to-derive (call goal) goal) ;; Can't do this in Prolog :p
    (to-derive (once goal)
               (call goal)
               !)
    
    (to-derive (atomic x) (or (atom x) (number x)))
    
    ;; is/2 the calculator
    (fact (is x x) (number x))
    ;; binary ops
    (to-derive (is z (+ x y))
               (is x-val x) (is y-val y) (%+ x-val y-val z))
    (to-derive (is z (- x y))
               (is x-val x) (is y-val y) (%- x-val y-val z))
    (to-derive (is z (- x))
               (is z (- 0 x)))
    (to-derive (is z (* x y))
               (is x-val x) (is y-val y) (%* x-val y-val z))
    (to-derive (is z (** x y))
               (is x-val x) (is y-val y) (%** x-val y-val z))
    (to-derive (is z (/ x y))
               (is x-val x) (is y-val y) (%/ x-val y-val z))
    (to-derive (is z (mod x y))
               (is x-val x) (is y-val y) (%mod x-val y-val z))
    (to-derive (is z (rem x y))
               (is x-val x) (is y-val y) (%rem x-val y-val z))
    ;; unary ops
    (to-derive (is z (sqrt x))    (is x-val x) (%sqrt x-val z))
    (to-derive (is z (sin x))     (is x-val x) (%sin x-val z))
    (to-derive (is z (cos x))     (is x-val x) (%cos x-val z))
    (to-derive (is z (asin x))    (is x-val x) (%asin x-val z))
    (to-derive (is z (acos x))    (is x-val x) (%acos x-val z))
    (to-derive (is z (abs x))     (is x-val x) (%abs x-val z))
    (to-derive (is z (floor x))   (is x-val x) (%floor x-val z))
    (to-derive (is z (round x))   (is x-val x) (%round x-val z))
    (to-derive (is z (ceiling x)) (is x-val x) (%ceiling x-val z))
    
    ;; basic list ops, compiled from Prolog code
    (fact (member V0 (cons V0 V1)))
    (to-derive (member V0 (cons V1 V2)) (member V0 V2))
    
    (fact (append 'nil V0 V0))
    (to-derive (append (cons V0 V1) V2 (cons V0 V3)) (append V1 V2 V3))
    
    (fact (select V0 (cons V0 V1) V1))
    (to-derive (select V0 (cons V1 V2) (cons V1 V3)) (select V0 V2 V3))
    
    (fact (permutation 'nil 'nil))
    (to-derive (permutation (cons V0 V1) V2) (and (permutation V1 V3) (select V0 V2 V3)))
    
    ;; A type checker/inferer for simply typed lambda calculus
    (to-derive (type V0 (of V1 V2))
               (and (atom V1) (member (of V1 V2) V0)))
    (to-derive (type V0 (of (lambda V1 V2) (-> V3 V4)))
               (type (cons (of V1 V3) V0) (of V2 V4)))
    (to-derive (type V0 (of (apply V1 V2) V3))
               (and (type V0 (of V1 (-> V4 V3))) (type V0 (of V2 V4))))
    
    ;; path finding
    ;;        a
    ;;      /   \ 
    ;;     b     g
    ;;    / \   / \
    ;;   c   f h   i
    ;;  / \          \
    ;; d   e          j
    ;;
    (fact (step 'a 'b)) (fact (step 'a 'g))
    (fact (step 'b 'c)) (fact (step 'b 'f))
    (fact (step 'c 'd)) (fact (step 'c 'e))
    (fact (step 'g 'h)) (fact (step 'g 'i))
    (fact (step 'i 'j))
    
    ;; depth first
    (fact (path x x (cons x 'nil)))
    (to-derive (path x y (cons x tail))
               (step x mid)
               (path mid y tail))
    
    ;; breadth first searching
    (to-derive (le x (s y))
               (le x y))
    (fact (le x x))
    
    (to-derive (path-length 'o    a z) (step a z))
    (to-derive (path-length (s n) a z) (step a b) (path-length n b z))
    
    (to-derive (path-bfs a z)
               (le n (s (s (s (s (s (s (s (s (s 'o)))))))))) ;; hard coded max bound
               (path-length n a z))
    
    ;; permutation sort
    (fact (less 'a 'b)) (fact (less 'a 'c)) (fact (less 'a 'd)) (fact (less 'a 'e))
    (fact (less 'a 'f)) (fact (less 'b 'c)) (fact (less 'b 'd)) (fact (less 'b 'e))
    (fact (less 'b 'f)) (fact (less 'c 'd)) (fact (less 'c 'e)) (fact (less 'c 'f))
    (fact (less 'd 'e)) (fact (less 'd 'f)) (fact (less 'e 'f))
    
    (fact (sorted 'nil))
    (fact (sorted (cons G180 'nil)))
    (to-derive (sorted (cons G180 (cons G183 G184)))
               (less G180 G183)
               (sorted (cons G183 G184)))
    
    (fact (permutation 'nil 'nil))
    (to-derive (permutation (cons G180 G181) G184)
               (permutation G181 G187)
               (select G180 G184 G187))
    
    (to-derive (permutation-sort G180 G181)
               (permutation G180 G181)
               (sorted G181))
    
    ;; Magic square generator, very slow
    (fact (saturn_digits (cons 1 (cons 2 (cons 3
                         (cons 4 (cons 5 (cons 6
                         (cons 7 (cons 8 (cons 9 'nil)))))))))))
    
    (to-derive (saturn (cons V0 (cons V1 (cons V2
                       (cons V3 (cons V4 (cons V5
                       (cons V6 (cons V7 (cons V8 'nil))))))))))
               (saturn_digits V9)
               (select V0 V9 V10)
               (select V1 V10 V11)
               (select V2 V11 V12)
               (select V3 V12 V13)
               (select V4 V13 V14)
               (select V5 V14 V15)
               (select V6 V15 V16)
               (select V7 V16 V17)
               (select V8 V17 'nil)
               (is V18 (+ (+ V0 V1) V2))
               (is V18 (+ (+ V3 V4) V5))
               (is V18 (+ (+ V6 V7) V8))
               (is V18 (+ (+ V0 V3) V6))
               (is V18 (+ (+ V1 V4) V7))
               (is V18 (+ (+ V2 V5) V8))
               (is V18 (+ (+ V0 V4) V8))
               (is V18 (+ (+ V2 V4) V6)))
    
    
    (fact (append 'nil V0 V0))
    (to-derive (append (cons V0 V1) V2 (cons V0 V3)) (append V1 V2 V3))

    (fact (lt-or-eq x x))
    (to-derive (lt-or-eq x (succ y))
               (lt-or-eq x y))
    
    (to-derive (binary-tree 'nil 'zero 'nil))
    (to-derive (binary-tree nodes (succ n) (branch left node right))
               (append left-nodes (cons node right-nodes) nodes)
               (lt-or-eq other-height n)
               (binary-tree left-nodes n left)
               (binary-tree right-nodes other-height right))
    (to-derive (binary-tree nodes (succ n) (branch left node right))
               (append left-nodes (cons node right-nodes) nodes)
               (lt-or-eq other-height n)
               (binary-tree left-nodes other-height left)
               (binary-tree right-nodes n right))
    
    
    ))

?- (binary-tree (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 'nil))))) (succ (succ (succ 'zero))) x)
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (branch (quote nil) 4 (quote nil)) 5 (quote nil))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (branch (quote nil) 4 (quote nil)) 5 (quote nil))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (quote nil) 4 (branch (quote nil) 5 (quote nil)))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (quote nil) 4 (branch (quote nil) 5 (quote nil)))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (branch (quote nil) 4 (quote nil)) 5 (quote nil))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (branch (quote nil) 4 (quote nil)) 5 (quote nil))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (quote nil) 4 (branch (quote nil) 5 (quote nil)))))
more? more
(= x (branch (branch (branch (quote nil) 1 (quote nil)) 2 (quote nil)) 3 (branch (quote nil) 4 (branch (quote nil) 5 (quote nil)))))
more? 

;; > (interact (make-database +prolog-db+))

;; ?- (append p q (cons 1 (cons 2 (cons 3 (cons 4 'nil)))))
;; (= p (quote nil))
;; (= q (cons 1 (cons 2 (cons 3 (cons 4 (quote nil))))))
;; more? more
;; (= p (cons 1 (quote nil)))
;; (= q (cons 2 (cons 3 (cons 4 (quote nil)))))
;; more? more
;; (= p (cons 1 (cons 2 (quote nil))))
;; (= q (cons 3 (cons 4 (quote nil))))
;; more? more
;; (= p (cons 1 (cons 2 (cons 3 (quote nil)))))
;; (= q (cons 4 (quote nil)))
;; more? more
;; (= p (cons 1 (cons 2 (cons 3 (cons 4 (quote nil))))))
;; (= q (quote nil))
;; more? more
;; no

;; cut examples
;; ?- (and (or (= x 1) (= x 5)) (and '! (or (= y 66) (= y 99))))
;; (= x 1)
;; (= y 66)
;; more? more
;; (= x 1)
;; (= y 99)
;; more? more
;; no
;; ?- (and (and (or (= x 1) (= x 5)) '!) (or (= y 66) (= y 99)))
;; (= x 1)
;; (= y 66)
;; more? more
;; (= x 1)
;; (= y 99)
;; more? more
;; no

;; benchmarking

;; ?- (permutation-sort (cons 'b (cons 'e (cons 'a (cons 'f (cons 'c (cons 'd 'nil)))))) sort)
;; doesn't take very long

;; ?- (saturn x)
;; takes very very long

(interact (make-database +prolog-db+))

