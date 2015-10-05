;; Saahil claypool & Josh Desmond
;; Homework 6


;;struct verion
#|
;; A dillo is a (make-dillo number boolean)
(define-struct dillo (length dead?))

;; longer-than? : dillo number -> boolean
;; is dillo longer than given length
(define (longer-than? adillo len)
  (> (dillo-length adillo) len))

;; run-over : dillo -> dillo
;; return dead dillo one unit longer than given dillo
(define (run-over adillo)
  (make-dillo (+ (dillo-length adillo) 1) true))
|#








(define-syntax class
  (syntax-rules (initvars method)
    [(class (initvars var ...)
       (method funName args fun) ...)
     (lambda (var ...)
       (lambda (message)
         (cond [(symbol=? message 'funName)
                (lambda args fun)] ...)))]
    [(class (initvars var ...))
     (lamda (var ...))]
    [(class (method funName args fun) ...)
     (lambda ()
       (lambda (message)
         (cond [(sybmol=? message 'funName)
                (lambda args fun)] ...)))]))

(define-syntax send
  (syntax-rules ()
    [(send obj message arg)
     ((obj 'message) arg)]
    [(send obj message)
     ((obj 'message))]))


;; Dillo-class
(define dillo-class
  (class (initvars length dead?)
         (method longer-than? (len) (> length len))
         (method run-over () (dillo-class (+ length 1) true))))


(define classNoMethod
  (class (initvars length dead?)
         ))

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


#|
(define d3 (dillo-class 5 false))
(send d3 longer-than? 6)
(send d3 longer-than? 5)
(define d4 (send d3 run-over))
(send d4 longer-than? 5)

|#



                 
#|

(define d3 (dillo-class 5 false))
(send d3 longer-than? 6)
(send d3 longer-than? 5)
(define d4 (send d3 run-over))
(send d4 longer-than? 5)
|#


;; Part One 


(define make-dillo-obj
  (lambda (length dead?)
    (lambda (message)
      (cond [(symbol=? message 'longer-than?) 
             (lambda (len) (> length len))]
            [(symbol=? message 'run-over) 
             (lambda () (make-dillo-obj (+ length 1) true))]))))

(define d1 (make-dillo-obj 5 false))
((d1 'longer-than?) 6)
((d1 'longer-than?) 5)
(define d2 ((d1 'run-over)))
((d2 'longer-than?) 5)




(define dillo-class
  (class (initvars length dead?)
         (method longer-than? (len) (> length len))
         (method run-over () (dillo-class (+ length 1) true))))

