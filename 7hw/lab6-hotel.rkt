;; Starter file for CS1102 lab 6 on state and web programming
;; Charles Rich (adapted from Kathi Fisler), WPI
(require racket/list)

(load "server.rkt") ;file must be in same folder

;; Note: Some advisable error checking is omitted here in order
;; not to clutter the code, so that the main pedagogical points
;; are more evident -CR

;;;;;;; DATA DEFINITIONS ;;;;;;;;;;;;;;;;;;;;;;;;

;; a hotel is (make-hotel symbol string)
(define-struct hotel (name descr))

(define HOTEL-DATA
  (list (make-hotel 'Motel6 "Wastes electricity by leaving lights on")
        (make-hotel 'Hilton "We'll always have Paris")
        (make-hotel 'DaysInn "Great for nights out")))

;;;;;;;;; VERSION 1 - NON-WEB MOCKUP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (hotel-main-page)
  (printf "Welcome! Which hotel do you want to view?~n")
  (print-choices HOTEL-DATA)
  (let ([chosen-hotel-number (read)])
    (if (or (not (number? chosen-hotel-number))
            (< chosen-hotel-number 0)
            (>= chosen-hotel-number (length HOTEL-DATA)))
        (hotel-main-page) ;invalid input
        (let* ([chosen-hotel (list-ref HOTEL-DATA chosen-hotel-number)]
               [chosen-hotel-name (hotel-name chosen-hotel)])
          (printf "Details for ~a: ~a~n~n" chosen-hotel-name (hotel-descr chosen-hotel))
          (printf "Enter the day of this month you want to reserve or no to skip this hotel: ~n~n")
          (let ([reserve-for (read)])
            (if (symbol=? reserve-for 'no) 
                (hotel-main-page)
                (printf "Congrats, you have a reservation at the ~a for day ~a of this month!~n" 
                        chosen-hotel-name reserve-for)))))))

;; print-choices : list[hotel] -> void
;; numbers hotel names and prints them out
(define (print-choices data)
  (for-each (lambda (numstr ahotel) 
              (printf "  ~a: ~a~n" numstr (hotel-name ahotel)))
            (build-list (length data) number->string)
            data))

;;;;;;;;; VERSION 2 - WEB VERSION WITH COOKIE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Note: 
;;   - assuming using local port 8088
;;   - following Version 1 as closely as possible in order to highlight
;;     comparison, rather than using fancy html (such as radio buttons)

(define-script (hotel-main-page form cookies) ;args ignored
  (values 
   (html-page "Hotel Main Page"
              "Welcome! Which hotel do you want to view?"
              (append (list 'form 
                            (list (list 'action "http://localhost:8088/reserve")
                                  (list 'target "_blank"))) ;in new window/tab
                      (format-choices HOTEL-DATA)
                      (list (list 'input (list (list 'type "text")
                                               (list 'name "choice"))))))
   ;; no cookie
   false))

(define-script (reserve form cookies)
  (let ([chosen-hotel-number (string->number (cdr (assoc 'choice form)))])
    (if (or (boolean? chosen-hotel-number)
            (< chosen-hotel-number 0)
            (>= chosen-hotel-number (length HOTEL-DATA)))
        (invoke "hotel-main-page" empty cookies) ;invalid input
        (let* ([chosen-hotel (list-ref HOTEL-DATA chosen-hotel-number)]
               [chosen-hotel-name (symbol->string (hotel-name chosen-hotel))])
          (values
           (html-page chosen-hotel-name
                      (format "Details for ~a: ~a" 
                              chosen-hotel-name (hotel-descr chosen-hotel))
                      (list 'br) (list 'br)
                      "Enter the day of this month you want to reserve or no to skip this hotel:"
                      (list 'form 
                            (list (list 'action "http://localhost:8088/confirm"))
                            (list 'input (list (list 'type "text")
                                               (list 'name "day")))))
           ;; send cookie
           (set-cookie "cs1102-hotel-choice" chosen-hotel-name))))))
   
(define-script (confirm form cookies)
  (let ([reserve-for (cdr (assoc 'day form))])
    (if (string=? reserve-for "no") 
        (invoke "hotel-main-page" form cookies)
        (values
         (html-page "Confirmation"
                    (format "Congrats, you have a reservation at the ~a for day ~a of this month!" 
                            (get-cookie/single "cs1102-hotel-choice" cookies)
                            reserve-for))
         ;; no cookie
         false))))

;; format-choices : list[hotel] -> list[string]
;; produces numbered list of hotel names
(define (format-choices data)
  (append-map (lambda (numstr ahotel) 
                (list (format "  ~a: ~a" numstr (hotel-name ahotel)) (list 'br)))
              (build-list (length data) number->string)
              data))
