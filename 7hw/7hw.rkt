;; Josh Desmond & Saahil Claypool
;; Homework 7
(require racket/list)
(load "server.rkt") ;file must be in same folder
(require test-engine/racket-gui)

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

;; POSTS is a list of posts
;(define POSTS empty)

;; EXAMPLEPOSTS
(define EXAMPLEPOSTS
  (list (post "Josh" "this is a post")
        (post "Saa" "this is <b>another</b> post")))
(define POSTS
  (list (post "Josh" "this is a post")
        (post "Saa" "this is <b>another</b> post")))

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
                NEWPOSTBUTTON
                (getsformatedposts POSTS))
   false))

;; NEWPOSTBUTTON
;; defines the html (in terms of racket lists) of the button to create a new post
(define NEWPOSTBUTTON
  (list 'form (list (list 'action "http://localhost:8088/authoring")) (list 'button "New Post")))

;; getsformatedposts: -> racket's html markup of all posts.
(define (getsformatedposts posts)
  (string->xexpr (formatposts posts)))

;; formatposts: list(post) -> string
;; creates an html formatted string of the post list
(define (formatposts posts)
  (wrapstringp
   (formatpostshelper "" posts)))

;; formatposthelper: string list(post) -> string
(define (formatpostshelper current restposts)
  (cond [(empty? restposts) current]
        [else (formatpostshelper (string-append current
                             (wrapstringp (post-author (first restposts)))
                             (wrapstringp (post-body (first restposts)))
                             ) (rest restposts))]))

;; TODO delete this:
;(define MOCKPOSTS
;  "<p><p>Josh</p><p>this is a post</p><p>Saa</p><p>this is <b>another</b> post</p></p>")
  ;"<p><p><p>Post 1 Written by Josh</p> Hello this is a post Post 2 written by Saa Hello this is <b>another</b> post</p></p>")
(check-expect (formatposts EXAMPLEPOSTS) "<p><p>Josh</p><p>this is a post</p><p>Saa</p><p>this is <b>another</b> post</p></p>")


;; wrapstringp: string -> string
;; wraps a string in <p> tags
(define (wrapstringp str)
  (string-append "<p>"
                 str
                 "</p>"))
(check-expect (wrapstringp "hello") "<p>hello</p>")


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


;; ----------------------------------------
;; {scriptauthoringpage}
#|
A field in which to enter your name
A field in which to enter the text of the post (which can include regular hmtl markup such as <b> ... </b> for bold face, etc.)
A preview button (which opens the preview page in a new window/tab---see "_blank" for target attribute in Lab 6 hotel code.)
|#
(define-script (authoring form cookies)
  (values
   (html-page "Authoring Page"
            (string->xexpr htmlString)  
              )
   false))


(define htmlString "<p><p>MakePost </p> 
<form action=\"http://localhost:8088/previewpage\">
<input type=\"text\" name=\"name\" placeholder=\"first\" />
<input type=\"text\" name=\"body\" placeholder=\"body\"/>
<input type=\"submit\" value= \"preview\" />
</form></p>")
#|
|#
;; ----------------------------------------
;; {scriptpreviewpage}
(define-script (previewpage form cookies)
  ; cdr takes second item in list. assoc finds pair with first field namein form
  (let* ([name (cdr (assoc 'name form))]
         [body (cdr (assoc 'body form))]
         [tempPosts (cons (post name body)
                          POSTS)])
  (values
   (html-page "preview page"
                (SubmitPost name body)
                CancelPost
                (getsformatedposts tempPosts)
                ;;hidden name body 
                )
   false)))

(define (SubmitPost name body)
  (list 'form
        (list
         (list 'action "http://localhost:8088/submitScript"))
        (list 'button "Submit")
        (list 'input (list (list 'type "hidden")
                           (list 'name "tempName")
                           (list 'value name)))
        (list 'input (list (list 'type "hidden")
                           (list 'name "tempBody")
                           (list 'value body)))))
(define CancelPost
  (list 'form (list (list 'action "http://localhost:8088/mainpage")) (list 'button "Cancel")))
;; ----------------------------------------
;; {scriptsubmitbutton}
(define-script (submitScript form cookies)
 (let* ([name (cdr (assoc 'tempName form))]
         [body (cdr (assoc 'tempBody form))]
         [tempPosts (cons (post name body)
                          POSTS)])
  (values
   (begin
     (set! POSTS tempPosts)
     (invoke "mainpage" empty cookies)
     )
   false)))

(test)