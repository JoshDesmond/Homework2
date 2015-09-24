;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 4hwk) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; Josh Desmond Saahil

;; A test is (make-test list[cmd])
(define-struct test (cmds))

;; A cmd is either
;; - (make askquestion question)
;; - (make hintquestion question hint-string) 
;; - (make testcond (??? -> boolean) list[cmd] list[cmd])
;; - (make displayprogress type)
;; - (make displaymessage string)
(define-struct askquestion (question))
(define-struct hintquestion (question hint-string))
(define-struct testcond (cond passed-cond failed-cond))
(define-struct displayprogress (type))
(define-struct displaymessage (string))


;; a question is either
;; a fill, or
;; a mult

;; a mult is a (make-mult string string (list strings) symbol) TODO Check formatting
(define-struct mult (problem answers choicelist type))

;; a fill is either
;; - (make-fill string string symbol), or
;; - (make-fill string (list string) symbol)
;; that is, answers can either be a list of strings
;; or a single string.
(define-struct fill (problem answer type))


;; getProgress: symbol -> number
;; takes in type of question, gives back % of those correct
;; 'all will give back total % correct
(define (getProgress category)
  0)


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
   (list (make-askquestion q1)
         (make-askquestion q2)
         (make-askquestion q3)
         (make-testcond (lambda () (< (getProgress 'arithmatic) .5)) ;;TODO
                        (list ;;true
                         (make-displaymessage "You seem to be having trouble with these. Try again.")
                         (make-askquestion qbad4)) 
                        (list empty)) ;;false
         (make-askquestion m5)
         (make-testcond (lambda () (< (getProgress 'arithmatic) .5))
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
     (list (make-askquestion q1)
           (make-displaymessage st1)
           (make-hintquestion h2
                              "Think bleating")
           (make-askquestion m3)
           (make-displayprogress 'personalities)
           (make-askquestion f4)
           (make-displayprogress 'all)
           (make-displaymessage "There's more WPI history on the web.  And life.")))))
        

                          
                          
                          
                          
                          
                          
                          
                          
                          
                          
                          