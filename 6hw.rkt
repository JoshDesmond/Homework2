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