;; Saahil claypool & Josh Desmond
;; Homework 6

;; Macro for class
(define-syntax class
  (syntax-rules (initvars method)
    [(class (initvars var ...) ;; class with methods & variables
       (method funName args fun) ...)
     (lambda (var ...)
       (lambda (message)
         (cond [(symbol=? message 'funName)
                (lambda args fun)] ...)))]
    [(class (initvars var ...)) ;; no methods
     (lamda (var ...))]
    [(class (method funName args fun) ...) ;; no variables
     (lambda ()
       (lambda (message)
         (cond [(sybmol=? message 'funName)
                (lambda args fun)] ...)))]))

;; Macro for send
(define-syntax send
  (syntax-rules ()
    [(send obj message arg)
     (let ([fun (obj 'message)])
       ;;if void -> error else val
       (cond [(void? fun) (error (format "Function undefined:  given ~a" 'message))]
             [else
              ((obj 'message) arg)]))]
    
    [(send obj message) ;; methods without arguments
     (let ([fun (obj 'message)])
       ;;if void -> error else val
       (cond [(void? fun) (error (format "Function undefined:  given ~a" 'message))]
             [else
              ((obj 'message))]))]))


;; Dillo-class, an example class using our notation.
(define dillo-class
  (class (initvars length dead?)
    (method longer-than? (len) (> length len))
    (method run-over () (dillo-class (+ length 1) true))))

;; dillo-class is converted into:
#|
(define make-dillo-obj
  (lambda (length dead?)
    (lambda (message)
      (cond [(symbol=? message 'longer-than?) 
             (lambda (len) (> length len))]
            [(symbol=? message 'run-over) 
             (lambda () (make-dillo-obj (+ length 1) true))]))))
|#

;; Example class without methods
(define classNoMethod
  (class (initvars length dead?)
    ))

;; Example class without variables
(define classNoVars
  (class 
      (method longer-than? (len) (> length len))
    (method run-over () (dillo-class (+ length 1) true))))


;;testing Send
(define d3 (dillo-class 5 false))
(send d3 longer-than? 6)
(send d3 longer-than? 5)
(define d4 (send d3 run-over))
(send d4 longer-than? 5)

;; These are converted into:
#|
(define d1 (make-dillo-obj 5 false))
((d1 'longer-than?) 6)
((d1 'longer-than?) 5)
(define d2 ((d1 'run-over)))
((d2 'longer-than?) 5)
|#


;; ========================================================
;; ======================== Part Two ======================
;; ========================================================

;; The macro

(define-syntax policy-checker
  (syntax-rules ()
    [(policy-checker
      (title (action ...) (object ...))
      ...)
     (let ([loactions ;; let definitions used in error checking
            (append (list 'action ...) ...)]
           [loobjects
            (append (list 'object ...) ...)])
       (lambda (a-title a-action a-object)
         (if (not (contains? a-action loactions)) ;; check if action is ever defined
             (error (format "given action was not found: ~a" a-action)))
         (if (not (contains? a-object loobjects)) ;; check if object is ever defined
             (error (format "given object was not found: ~a" a-object)))
         (cond [(symbol=? 'title a-title) ;; filter through
                (and (contains? a-action (list 'action ...))
                     (contains? a-object (list 'object ...)))]
               ... ;; asks a conditional for every title/policy.
               [else (error (format "given title was not found: ~a" a-title))]
  ;;             [else (error (format "given title was not found: ~a" a-title))]
               )))]))

;; contains?: atom list -> boolean
;; returns true if the list contains the given item
(define (contains? item list)
  (cons? (member item list))) ;; because member returns a list if the item is a member of the list,
;; asking cons? will return false if member returned false, and true
;; if member returned a list.

;; This is an example of a policy written in our target language
(define check-policy
  (policy-checker
   (programmer (read write) (code documentation))
   (tester (read) (code))
   (tester (write) (documentation))
   (manager (read write) (reports))
   (manager (read) (documentation))
   (ceo (read write) (code documentation reports))))

;; These are example calls in our language. 
(check-policy 'programmer 'write 'code) ;; returns true
(check-policy 'programmer 'write 'reports) ;; returns false
(check-policy 'tester 'read 'code) ;; Returns true
(check-policy 'manager 'write 'code) ;;returns false
(check-policy 'progrrmer 'write 'code) ;; returns an error, title not found
(check-policy 'programmer 'wrt 'code) ;; returns an error, aciton not found
(check-policy 'programmer 'write 'cde) ;; returns an error, object not found
