;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 3hwk) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")))))
;;  ============Structures============
;;(define-struct file(name size content))
;;(define-struct dir(name dirs files))
;; list-of-directory is either...
;; list-of-files is either...
;; =============Functions=============
;; any-huge-files?: (filesystem and a number -> boolean)
     ;; convert filesystem to list, filter the list -> list, false if 0.
;; clean-directory: (filesystem and an existing directory name -> filesystem)
     ;; for every directory, compare to the direcotry name, then get the list of files in the given directory, and filter the list of files in it.
;; find-file-path: (filesystem and a filename -> list of directory names, or FALSE)
     ;; for every directory, filter list -> list, if empty false
;; file-names-satisfying: (filesystem and a function from file to boolean -> list of names of files
     ;; Convert filesystem to list, map list -> list
;; files-containing: (filesystem and a value -> list of names of files)


#|
root: - lod: dir-r1, dir-r2, dir-r3
      - lof: (make-file (r2
dir-r1: - lod: empty
        - lof: (make-file ('r1f 10 'test))
dir-r2: - lod: dir-r2-1
        - lof: empty
dir-r3: - lod: empty
        - lof: file
dir-r2-1: - lod: empty
          - lof: file, file, file

;; folders:
(define F1 (make-dir 'f1 empty empty))
(define F2 (make-dir 'f2 empty 

;; Files:
(define FLARGE1 (make-file 'flarge1 200 'large))
(define FLARGE2 (make-file 'flarge2 200 'large))
(define FMED1 (make-file 'med1 100 'med))
(define FSMALL1 (make-file 'small1 5 'small))
(define FSMALL2 (make-file 'small2 6 (+ 5 5)))
(define FZERO (make-file 'zero1 0 "zero"))

(define LOF-F1 (list(FLARGE

root: empty



dir -> lod -> dir -> lod -> dir -> lod -> dir end -> lof -> lof -> lof

|#


;; directory 3: name List of directory List of Files
;; 2 list templates, and 1 directory template

;;file is a (make-file symbol number value)
;; symbol is name, s is size x is content
(define-struct file(name size content))
#|fileFun
(define (fileFun a-file)
  (file-name a-file)...
  (file-size a-file) ...
  (file-content a-file)...
|#

;;list-of-files is either
;; empty
;; (cons s lof) s is file, lof is a list of files


;; dir is (make-dir symbol list-of-directory list-of-file)
(define-struct dir(name dirs files))
#|Dir template
(define (dirFun a-dir)
  (dir-name a-dir)...
  (LODFun (first (dir-dirs a-dir))) ...
  (LOFFun (first (dir-files a-dir)))...

|#


;;list-of-directory is either
;; empty
;; (cons s lod) where s is a symbol name and lod is a list of directories

#|LOD template
(define (LODFun a-LOD)
   (cond [(empty? a-list) ...]
         [(cons? a-list) (dirFun(first a-LOD)) ...
                         (LODFun (rest a-LOD))...]
|#

;; A file system is either
;; 'empty or,
;; a dir
#|fileSystem template
 (define (FSFun a-FS)
   (cond [(symbol? a-FS) ...]
         [(dir? a-FS) (dirFun a-dir)]))
  

|#



(define LOF1 (list (make-file '0 0 empty)))
(define LOF2 (list (make-file '0 0 empty) 
                   (make-file '1 1 empty)))
(define LOF3 (list (make-file '0 0 empty)
                   (make-file '1 1 empty)
                   (make-file '2 2 empty)))
;; example file systems
(define FS1 (make-dir '1 empty LOF1))
(define FS2 (make-dir '2 (list FS1) LOF2))
(define FS3 (make-dir '3 (list FS1 FS2) LOF3))


 ;;any-huge-files?: FS num -> bool
;; consumes a File System and a number,
;;returns true if a file is above that size
(define (any-huge-files? a-FS num)
  (cond[(symbol? a-FS) false]
       [(dir? a-FS) (or
                     (any-huge-files-LOF? (dir-files a-FS) num)
                     (any-huge-files-DIR?  (dir-dirs a-FS) num))]))
(check-expect (any-huge-files? FS3 0)
              true)
(check-expect (any-huge-files? FS3 100)
              false)
;; any-huge-files-DIR?: LOD-> bool
;; determines if a LOD has a huge file
(define (any-huge-files-DIR? a-LOD num)
  (do-any-satisfy-condition? a-LOD (lambda (a-dir) (any-huge-files? a-dir num))))
;; tests:
(check-expect (any-huge-files-DIR? (dir-dirs FS3) 0) true)
;;any-huge-files-LOF?: LOF num -> bool
;; determines if there is ahuge file in a list

 (define (any-huge-files-LOF? a-LOF num)
   (do-any-satisfy-condition?  a-LOF (lambda (a-file) (> (file-size a-file) num))))
(check-expect (any-huge-files-LOF? LOF3 1) true)
(check-expect (any-huge-files-LOF? LOF3 2) false)

;; anyleft? list[alpha] (alpha -> bool) -> bool
(define (do-any-satisfy-condition? list fun)
  (> (length
      (filter
       fun list)
      )
     0))

;; clean-directory: FS symbol -> FS