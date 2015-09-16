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


;; For use in test cases for the following four functions:
(define FN-1 (make-file 'a 5 0))
(define FN-2 (make-file 'a 5 1))
(define FS-1 (make-file 'a 5 's))
(define NUMBERS1 (make-dir 'numbers1 empty (list FN-1 FN-1)))
(define NUMBERS (make-dir 'numbers (list NUMBERS1 NUMBERS1) (list FN-1 FN-1)))
(define NUMBERS-21 (make-dir 'numbers1 empty (list FN-2 FN-2)))
(define NUMBERS-2 (make-dir 'numbers (list NUMBERS-21 NUMBERS-21) (list FN-2 FN-2))) 

(define FILTERNUM (lambda (lof) (filter (lambda (f) (number? (file-content f))) lof)))
(define MIXED1 (make-dir 'm1 empty (list FN-1 FN-2 FS-1)))
(define MIXED-21 (make-dir 'm1 empty (list FN-1 FN-2)))
(define MIXED (make-dir 'm (list MIXED1 MIXED1) (list FN-1)))
(define MIXED-2 (make-dir 'm (list MIXED-21 MIXED-21) (list FN-1)))

;; =============High Level Functions==============
;; apply-dir: (a-dir, (list[files] -> x) -> a-dir)
;; Applies the given lof-fun to every single lof
;; throughout the entire file system
(define (apply-dir a-dir lof-fun)
  (cond [(empty? a-dir) empty]
        [else (make-dir (dir-name a-dir) (apply-lod (dir-dirs a-dir) lof-fun) (lof-fun (dir-files a-dir)))]))
;; apply-lod: (a-lod, (list[files]-> x) -> a-lod)
;; Applies the given lof-fun to every single lof
;; in every directory in the list, and within all
;; subdirectories/throughout the entire file system.
(define (apply-lod a-lod lof-fun)
  (cond [(empty? a-lod) empty]
        [else (cons (apply-dir (first a-lod) lof-fun) (apply-lod (rest a-lod) lof-fun))]))

;; Test Cases:
(check-expect (apply-dir NUMBERS (lambda (lof) (map (lambda (f) (make-file (file-name f) (file-size f) (+ 1 (file-content f)))) lof))) NUMBERS-2)
(check-expect (apply-dir MIXED FILTERNUM) MIXED-2)

;; filter-dir: (a-dir, (file->boolean) -> a-dir)
;; Returns a directory with all files removed
;; or filtered out that cause the boolean test to
;; return false.
(define (filter-dir a-dir file-cond)
  (apply-dir a-dir (lambda (lof) (filter file-cond lof))))
(check-expect (filter-dir MIXED (lambda (f) (number? (file-content f)))) MIXED-2)

;; map-dir (a-dir, (file->file) -> a-dir)
;; Returns a directory with the given function
;; applied to every single file in the entire
;; file system.
(define (map-dir a-dir file-fun)
  (apply-dir a-dir (lambda (lof) (map file-fun lof))))
;; Test Cases
(check-expect (map-dir NUMBERS (lambda (f) (make-file (file-name f) (file-size f) (+ 1 (file-content f))))) NUMBERS-2)





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


;;;Abstraction: 
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
;; consumes file system and a name of a directory, removes all
;; files size 0 in that directory

;; find-file-path: FS symbol -> False OR list of symbol
;; takes in a file system and a file name, gives back the list of dir
;; names to get to that file

;; files-names-satisfying: FS (file -> bool) -> List of symbol
;; gives list of names where (file->bool) bill be true for all files

;; files-containing: FS value -> list of sybol
;; takes in a file system and uses file-names-satisfying to give back
;; a list of file names where each file has the given value as its contents

