;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 4hwk) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")))))
;; Josh Desmond Saahil

;; A test is (make-test list[cmd])
(define-struct test (cmds))

;; A cmd is either
;; - (make askquestion question)
;; - (make hintquestion question hint-string) 
;; - (make testcond (??? -> boolean) list[cmd] list[cmd])
;; - (make displayprogress type)
(define-struct askquestion (question))
(define-struct hintquestion (question hint-string))
(define-struct testcond (cond passed-cond failed-cond))
(define-struct displayprogress (type))

;; a question is either 
;; (make-fill string string symbol), or
;; (make-mult string string (list strings) symbol)
(define-struct fill (problem answer type))
(define-struct mult (problem answer choicelist type))



#|
(make-question "What is 3*4+2?" "14" 'arithmetic)
(make-question "What is 2+3*4?" "14" 'arithmetic)
(make-question "What is 5+2*6?" "17" 'arithmetic)
(make-question "You seem to be having trouble with these. Try again.\nWhat is 5+2*6?" "13" 'arithmetic)
(make-question "What is 8+3*2" 

|#

(define test1
  (let )
  (make-test
   (list (make-askquestion q1)
         (make-askquestion q2)
         (make-askquestion q3)
         (make-testcond ({do you have less than 50% so far?})
                        (list qf4) ;;true
                        (list empty)) ;;false
         (make-askquestion m5)
         (make-testcond ({do you have less than 50% on arithmetic?})
                        (list qf6) ;;true
                        (list qt6)) ;;false
         (make-displayprogress 'arithmetic)
         (make-displayprogress 'fractions))
   ))
   
   
   
   
   
   
   
   
   
   
   