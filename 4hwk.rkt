;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 4hwk) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;; Josh Desmond Saahil

;; A test is (make-test list[symbol] list[cmd])
;; a test will keep track of progress on all question types which match the given symbol
;; by default, tests will keep track of your total progress.This can be accessed using the symbol 'all
(define-struct test (types cmds))

;; A cmd is either
;; - (make askquestion question)
;; - (make hintquestion question hint-string) 
;; - (make testcond (number -> boolean) symbol list[cmd] list[cmd])
;;         testcond will evaluate the lambda function using the percentage-correct,
;;         of the category specified.
;; - (make displayprogress type)
;; - (make displaymessage string)
(define-struct askquestion (question))
(define-struct hintquestion (question hint-string))
(define-struct testcond (cond type passed-cond failed-cond))
(define-struct displayprogress (type))
(define-struct displaymessage (string))


;; a question is either
;; a fill, or
;; a mult

;; a mult is a (make-mult string string list[string] symbol) 
(define-struct mult (problem answers choicelist type))

;; a fill is either
;; - (make-fill string string symbol), or
;; - (make-fill string (list string) symbol)
;; that is, answers can either be a list of strings
;; or a single string.
(define-struct fill (problem answer type))


(define test1
  (let ([q1
         (make-fill "What is 3*4+2?" "14" 'arithmetic)]
        [q2
         (make-fill "What is 2+3*4?" "14" 'arithmetic)]
        [q3
         (make-fill "What is 5+2*6?" "17" 'arithmetic)]
        [qbad4
         (make-fill "What is 3+5*2?" "13" 'arithmetic)]
        [m5
         (make-mult "What is the reduced form of 12/18?" "2/3" 
                    (list "6/9" "1/1.5" "2/3") 'fractions)]
        [qbad6
         (make-fill "What is 8+3*2" "14" 'arithmetic)]
        [qwell6
         (make-mult "What is 1/4 + 1/2?" "3/4" 
                    (list "3/4" "1/6" "2/6") 'fractions)])
  (make-test
   (list 'arithmetic 'fractions)
   (list (make-askquestion q1)
         (make-askquestion q2)
         (make-askquestion q3)
         (make-testcond (lambda (number) (< number .5))
                        'arithmetic 
                        (list ;;true
                         (make-displaymessage "You seem to be having trouble with these. Try again.")
                         (make-askquestion qbad4)) 
                        (list empty)) ;;false
         (make-askquestion m5)
         (make-testcond (lambda (number) (< number .5))
                        'arithmetic
                        (list (make-askquestion qbad6)) ;;true
                        (list (make-askquestion qwell6))) ;;false
         (make-displayprogress 'arithmetic)
         (make-displayprogress 'fractions)))))
   
(define test2
  (let ([q1
         (make-fill "When was WPI founded?"
                    "1865"
                    'general)]
        [st1
         "Let's see if you know your WPI personalities"]
        [h2
         (make-fill "What is Gompei?"
                    "goat"
                    'personalities)]
        [m3
         (make-mult "Who was the first president of WPI?"
                    "Thompson"
                    (list "Boyton" "Washburn" "Thompson")
                    'personalities)]
        [f4
         (make-fill "Name on of the two towers behind a WPI education"
                    (list "theory"
                          "practice")
                    'general)])
    (make-test
     (list 'personalities)
     (list (make-askquestion q1)
           (make-displaymessage st1)
           (make-hintquestion h2
                              "Think bleating")
           (make-askquestion m3)
           (make-displayprogress 'personalities)
           (make-askquestion f4)
           (make-displayprogress 'all) ;; 'all is a special symbol, that represents printing your total percentage correct.
           (make-displaymessage "There's more WPI history on the web.  And life.")))))
        

                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          