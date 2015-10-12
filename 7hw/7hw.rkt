;; Josh Desmond & Saahil Claypool
;; Homework 7
(require racket/list)
(load "server.rkt") ;file must be in same folder

#|
Hint: You will need to define four scripts:
    Three: (one) each to create the main, authoring and preview pages, and
    one to handle the accept button.

Review the Lab 6 hotel code for examples of how to manipulate HTML, but don't commit the same
error of using a cookie in the wrong way (follow your hidden field revision).
|#

;; ===================================================
;; =================== Data Def. =====================
;; ===================================================

;; a post is a (make-post string string)
(define-struct post (author body))

(define POSTS empty)

;; ===================================================
;; ==================== Scripts ======================
;; ===================================================

;; ----------------------------------------
;; {scriptmainpage}
;; Should get from server, list of posts,
;; then call html-page with html formatted
;;  -list of posts
;;       1. name of poster
;;       2. text of post
(define-script (mainpage form cookies)
  (values
   (html-page "Main page"
              (getsformatedposts))
   false))


;; getsformatedposts: -> racket's html markup of all posts.
(define (getsformatedposts)
  (list 'form (list (list 'action "http://localhost:8088/authoring")) (list 'button (list 'type "submit") "Submit")))


#| Template script from lab 6 for reference
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
|#

#|
<form action="demo_form.asp" method="get"><button type="submit">Submit</button><br></form>
|#


;; ----------------------------------------
;; {scriptauthoringpage}
(define-script (authoring form cookies)
  (values
   (html-page "Main page"
              "Hellooo")
   false))
;; ----------------------------------------
;; {scriptpreviewpage}

;; ----------------------------------------
;; {scriptsubmitbutton}