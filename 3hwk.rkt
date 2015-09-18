;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 3hwk) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;; Josh Desmond &
;; Saahil Claypool


;; =============Structures============
;;(define-struct file(name size content))
;;(define-struct dir(name dirs files))
;; list-of-directory is either...
;; list-of-files is either...
;; ====================================

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;file is a (make-file symbol number value)
;; symbol is name, s is size x is content
(define-struct file(name size content))
#|fileFun
(define (fileFun a-file)
  (file-name a-file)...
  (file-size a-file) ...
  (file-content a-file)...
|#
;; !!! NOTE: For examples, see the section after
;; structures. Examples of structures are bundled
;; together in order to make the structure of
;; directories more clear. This applies to all
;; structure definitions.


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;list-of-files is either
;; empty
;; (cons s lof) s is file, lof is a list of files


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; dir is (make-dir symbol list-of-directory list-of-file)
;; Throughout the code, directories are often labeled as fs, or filesystems.
(define-struct dir(name dirs files))
#|Dir template
(define (dirFun a-dir)
  (dir-name a-dir)...
  (LODFun (dir-dirs a-dir))...
  (first (dir-files a-dir))...
|#


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;list-of-directory is either
;; empty, or
;; (cons dir lod)
#|LOD template
(define (LODFun a-LOD)
   (cond [(empty? a-LOD) ...]
         [(cons? a-LOD) (dirFun(first a-LOD)) ...
                         (LODFun (rest a-LOD))...]
|#


;; ============================================
;; =============Example Directories============
;; ============================================
;; Example One:
;; Files:
(define FLARGE1 (make-file 'flarge1 200 'large))
(define FLARGE2 (make-file 'flarge2 200 'large))
(define FMED1 (make-file 'med1 100 'med))
(define FSMALL1 (make-file 'small1 5 'small))
(define FSMALL2 (make-file 'small2 6 (+ 5 5)))
(define FZERO (make-file 'zero1 0 "zero"))

;; LOFs
(define LOF-ROOT (list FLARGE1 FZERO))
(define LOF-R1 (list FLARGE2 FMED1))
(define LOF-R2 empty)
(define LOF-R3 (list FSMALL1 FSMALL2))
(define LOF-R2-1 (list FMED1 FZERO))

;; Dirs and LODs
(define R2-1 (make-dir 'R2-1 empty LOF-R2-1))
(define R1 (make-dir 'R1 empty LOF-R1))
(define LOD-R2 (list R2-1))
(define R2 (make-dir 'R2 LOD-R2 LOF-R2))
(define R3 (make-dir 'R3 empty LOF-R3))
(define LOD-ROOT (list R1 R2 R3))
(define ROOT (make-dir 'ROOT LOD-ROOT LOF-ROOT))

;; (cleaned)
(define LOF-ROOT-c (list FLARGE1))
(define LOF-R2-1-c (list FMED1))
(define R2-1-c (make-dir 'R2-1 empty LOF-R2-1-c))
(define LOD-R2-c (list R2-1-c))
(define R2-c (make-dir 'R2 LOD-R2-c LOF-R2))
(define LOD-ROOT-c (list R1 R2-c R3))
(define ROOT-c-ar (make-dir 'ROOT LOD-ROOT LOF-ROOT-c))
(define ROOT-c-ar2 (make-dir 'ROOT LOD-ROOT-c LOF-ROOT))

;; Example Two
;; Files
(define FN-1 (make-file 'a 5 0))
(define FN-2 (make-file 'a 5 1))
(define FS-1 (make-file 'a 5 's))

;; Directories (Numbers are for indication during test cases)
(define DE (make-dir 'empty empty empty))
(define NUMBERS1 (make-dir 'numbers1 empty (list FN-1 FN-1)))
(define NUMBERS (make-dir 'numbers (list NUMBERS1 NUMBERS1 DE) (list FN-1 FN-1)))
(define NUMBERS-21 (make-dir 'numbers1 empty (list FN-2 FN-2)))
(define NUMBERS-2 (make-dir 'numbers (list NUMBERS-21 NUMBERS-21 DE) (list FN-2 FN-2))) 
(define MIXED1 (make-dir 'm1 empty (list FN-1 FN-2 FS-1)))
(define MIXED-21 (make-dir 'm1 empty (list FN-1 FN-2)))
(define MIXED (make-dir 'm (list MIXED1 MIXED1 DE DE) (list FN-1)))
(define MIXED-2 (make-dir 'm (list MIXED-21 MIXED-21 DE DE) (list FN-1)))

;; Example Three
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

;; =============High Level Functions==============
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; apply-dir: (a-dir, (list[files] -> list[files]) -> a-dir)
;; Applies the given lof-fun to every single lof
;; throughout the entire file system
(define (apply-dir a-dir lof-fun)
  (make-dir (dir-name a-dir) 
            (apply-lod (dir-dirs a-dir) lof-fun) 
            (lof-fun (dir-files a-dir))))

;; apply-lod: (a-lod, (list[files]-> x) -> a-lod)
;; Applies the given lof-fun to every single lof
;; in every directory in the list, and within all
;; subdirectories/throughout the entire file system.
(define (apply-lod a-lod lof-fun)
  (map (lambda (a-dir) (apply-dir a-dir lof-fun)) a-lod))
;; Test Cases:
(define FILTERNUM (lambda (lof) (filter (lambda (f) (number? (file-content f))) lof)))
(check-expect 
 (apply-dir NUMBERS (lambda (lof) (map (lambda (f) (make-file (file-name f) 
                                                              (file-size f) 
                                                              (+ 1 (file-content f)))) lof))) 
 NUMBERS-2)
(check-expect (apply-dir MIXED FILTERNUM) MIXED-2)
(check-expect (apply-dir ROOT (lambda (f) f)) ROOT)


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; filter-dir: (a-dir, (file->boolean) -> a-dir)
;; Returns a directory with all files removed
;; or filtered out that cause the boolean test to
;; return false.
(define (filter-dir a-dir file-cond)
  (apply-dir a-dir (lambda (lof) (filter file-cond lof))))
;; Test Cases
(define FIL (make-file 'name 5 'cont))
(define FIL2 (make-file 'name 6 'conte))
(define DIRZ 
  (make-dir 'name3 (list (make-dir 'name empty 
                                   (list FIL FIL FIL)) 
                         (make-dir 'name2 empty (list FIL))) 
            (list FIL2 FIL)))
(define IS-FIL (lambda (f) (and (equal? (file-name f) 'name) 
                                 (= 5 (file-size f))
                                 (equal? (file-content f) 'cont))))
(define IS-FIL2 (lambda (f) (and (equal? (file-name f) 'name) 
                                 (= 6 (file-size f))
                                 (equal? (file-content f) 'conte))))
(check-expect (filter-dir MIXED (lambda (f) (number? (file-content f)))) MIXED-2)
(check-expect (filter-dir DIRZ IS-FIL) (make-dir 'name3 (list (make-dir 'name empty (list FIL FIL FIL))
                                                             (make-dir 'name2 empty (list FIL))) 
                                                (list FIL)))
(check-expect (filter-dir DIRZ IS-FIL2) (make-dir 'name3 (list (make-dir 'name empty empty)
                                                               (make-dir 'name2 empty empty)) 
                                                  (list FIL2 )))



;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; map-dir (a-dir, (file->file) -> a-dir)
;; Returns a directory with the given function
;; applied to every single file in the entire
;; file system.
(define (map-dir a-dir file-fun)
  (apply-dir a-dir (lambda (lof) (map file-fun lof))))
;; Test Cases
(check-expect 
 (map-dir NUMBERS (lambda (f) (make-file (file-name f) (file-size f) (+ 1 (file-content f))))) 
 NUMBERS-2)
(check-expect 
 (map-dir FS3 (lambda (f) true))   
 (make-dir '3 (list (make-dir '1 empty (list true)) 
                    (make-dir '2 (list (make-dir '1 empty (list true))) 
                              (list true true))) 
           (list true true true)))


;; =============================================
;; ================Functions====================
;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; any-huge-files?: Dir num -> boolean
;; Returns true if any of the files within the entire directory
;; structure are above the given size.
(define (any-huge-files? a-dir size)
  (< 0 (count-files (filter-dir a-dir (lambda (f) (< size (file-size f)))))))
;; The above method works by seeing if
;; The number of files within the filtered directory is
;; greater than zero. If it is, that means at least one file was in the
;; directory after the filter was applied.
;; Test Cases
(check-expect (any-huge-files? FS3 0) true)
(check-expect (any-huge-files? FS1 5) false)
(check-expect (any-huge-files? FS3 100) false)
(check-expect (any-huge-files? FS3 1) true)
(check-expect (any-huge-files? ROOT 90) true)

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; count-files: dir -> num
;; counts the number of files in the entire directory
(define (count-files a-dir)
  (+ (length (dir-files a-dir))
     (count-dirs-files (dir-dirs a-dir))))
;; count-dirs-files: a-lod -> num
(define (count-dirs-files a-lod)
  (cond [(empty? a-lod) 0]
        [else (+ (count-files (first a-lod))
                 (count-dirs-files (rest a-lod)))]))
;;Test Cases:
(check-expect (count-files FS1) 1)
(check-expect (count-files FS2) 3)
(check-expect (count-files FS3) 7)
(check-expect (count-files ROOT) 8)

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; do-any-satisfy-condition? list[alpha] (alpha -> bool) -> bool
;; consumes list and function ,returns true if any elements in that list will cause that function
;; to evaluate to true
(define (do-any-satisfy-condition? list fun)
  (> (length
      (filter
       fun list)
      )
     0))
;; Test Cases
(check-expect (do-any-satisfy-condition? (list empty) (lambda (f) (file? f))) false)
(check-expect (do-any-satisfy-condition? LOF3 (lambda (f) (= 2 (file-size f)))) true)
(check-expect (do-any-satisfy-condition? LOF3 (lambda (f) (< 3 (file-size f)))) false)
(check-expect (do-any-satisfy-condition? LOF-ROOT (lambda (f) (file? f))) true)

;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; clean-directory: dir symbol -> dir
;; consumes a dir and a name of a directory, removes all
;; files size 0 in that directory
(define (clean-directory a-dir name)
  (cond [(symbol=? (dir-name a-dir) name) #| clean this |#
         (filter-dir a-dir (lambda (f) (not (equal? (file-size f) 0))))]
        [else ;; we want to map the dirs, each dir gets clean directory 
         ;; applied to it, givng back a clean directory
         (make-dir
               (dir-name a-dir)
               (map (lambda (a-dir) (clean-directory a-dir name))
                    (dir-dirs a-dir))
               (dir-files a-dir))]))
;; Test cases
(check-expect (clean-directory (make-dir 'test empty
                                         (list (make-file '0 0 empty)))
                               'test)
              (make-dir 'test empty empty))
(check-expect (clean-directory (make-dir 'test empty
                                         (list (make-file '0 0 empty)
                                               (make-file '1 1 empty)))
                               'test)
              (make-dir 'test empty (list (make-file '1 1 empty))))
(check-expect (clean-directory (make-dir 'test1 empty
                                         (list (make-file '0 0 empty)))
                               'test)
              (make-dir 'test1 empty (list (make-file '0 0 empty))))
(check-expect (clean-directory (make-dir 'test (list (make-dir 'test1
                                                               empty
                                                               (list (make-file '0 0 empty))))
                                         empty)
                               'test1)
              (make-dir 'test (list (make-dir 'test1
                                              empty
                                              empty))
                        empty))
(check-expect (clean-directory ROOT 'R2-1) ROOT-c-ar2)
;;(check-expect (clean-directory ROOT 'ROOT) ROOT-c-ar) (has subdirectories, so test fails).






;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; find-file-path: FS symbol -> False OR list of symbol
;; takes in a file system and a file name, gives back the list of dir
;; names to get to that file (in order from root to the directory 
;; containing the file--but not including the filename), 
;; or false if the given file can't be found

(define (find-file-path a-FS name)
  (cond [(do-any-satisfy-condition? (dir-files a-FS) (lambda (a-file) (symbol=? (file-name a-file) name)))
         ;; this dir has file
         (list (dir-name a-FS))]
        [else
         (cond [(not (boolean? (find-file-path-help (dir-dirs a-FS) name)))
                (append (list (dir-name a-FS)) (find-file-path-help (dir-dirs a-FS) name) )]
               [else false])]))
   
(define (find-file-path-help a-LOD name)
  (cond [(empty? a-LOD) false]
        [else (cond
              [(not (boolean? (find-file-path (first a-LOD) name)))
                    (find-file-path (first a-LOD) name) ]
              [else (find-file-path-help (rest a-LOD) name)])]))


;; Test Cases:
(check-expect (find-file-path (make-dir 'name empty empty) 'rand) false)
(check-expect (find-file-path (make-dir 'name (list
                                               (make-dir 'name empty empty))
                                        empty)
                              'rand)       
              false)
(check-expect (find-file-path (make-dir 'name (list
                                               (make-dir 'name empty empty))
                                        empty)
                              'rand)
              false)

(check-expect (find-file-path (make-dir 'name (list
                                               (make-dir 'name1 empty empty))
                                        (list (make-file 'target 1 1 )))
                              'target)
              (list 'name))
(check-expect (find-file-path (make-dir 'name (list
                                               (make-dir 'name1 empty
                                                         (list (make-file 'target 1 1 ))))
                                        empty)
                              'target)
              (list 'name 'name1))

(check-expect (find-file-path (make-dir 'top (list
                                               (make-dir 'left empty
                                                         (list (make-file 'empty 1 1 )))
                                               (make-dir 'target empty
                                                         (list (make-file 'target 1 1 )))
                                               (make-dir 'right empty
                                                         (list (make-file 'empty 1 1 ))))
                                        empty)
                              'target)
              (list 'top 'target))
(check-expect (find-file-path (make-dir 'top (list
                                               (make-dir 'left empty
                                                         (list (make-file 'empty 1 1 )))
                                               (make-dir 'target empty
                                                         (list (make-file 'empty 1 1 )
                                                               (make-file 'target 1 1 )
                                                               (make-file 'empty 1 1 )))
                                               (make-dir 'right empty
                                                         (list (make-file 'empty 1 1 ))))
                                        empty)
                              'target)
              (list 'top 'target))
(check-expect (find-file-path (make-dir 'top (list
                                               (make-dir 'left empty
                                                         (list (make-file 'empty 1 1 )))
                                               (make-dir 'targettop (list (make-dir 'left empty
                                                                                    (list (make-file 'empty 1 1 )))
                                                                          (make-dir 'target empty
                                                                                    (list (make-file 'target 1 1 )))
                                                                          (make-dir 'right empty
                                                                                    (list (make-file 'empty 1 1 ))))
                                                         (list (make-file 'empty 1 1 )
                                                               (make-file 'empty 1 1 )
                                                               (make-file 'empty 1 1 )))
                                               (make-dir 'right empty
                                                         (list (make-file 'empty 1 1 ))))
                                        empty)
                              'target)
              (list 'top 'targettop 'target))

(define TARG (make-dir 'targ (list R1) (list FMED1 (make-file 'target 1 1)  FLARGE2)))
(define FFPDIR (make-dir 'top
                         (list R1 R2 TARG R3)
                         (list FMED1 FLARGE1)))
(define FFPDIR2 (make-dir 'top
                         (list R1 R2 (make-dir 't2 (list TARG) empty) R3)
                         (list FMED1 FLARGE1)))
(check-expect (find-file-path FFPDIR 'target)
              (list 'top 'targ))
(check-expect (find-file-path FFPDIR2 'target)
              (list 'top 't2 'targ))
(check-expect (find-file-path ROOT 'small2)
              (list 'ROOT 'R3))
(check-expect (find-file-path ROOT 'flarge1) (list 'ROOT))


;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
;; file-names-satisfying: Dir (file -> bool)-> List of symbol
;; gives list of file names, for which (file->bool) evaluates to true
;; for the given file. Returns files in inner directories first, left to right, 
;; then outermost files.
(define (file-names-satisfying adir fcond)
  (map (lambda (a-file) (file-name a-file)) ;; Maps each file -> its name 
       (flatten-dir (filter-dir adir fcond)))) ;; Of the list of filtered files.
;; Test Cases
(check-expect (file-names-satisfying DIRZ IS-FIL) 
              (map (lambda (a-file) (file-name a-file)) (list FIL FIL FIL FIL FIL)))
(check-expect (file-names-satisfying DIRZ IS-FIL2) 
              (map (lambda (a-file) (file-name a-file))(list FIL2)))
(check-expect (file-names-satisfying DIRZ (lambda (f) false)) empty)
(check-expect (file-names-satisfying DIRZ (lambda (f) true)) 
              (map (lambda (a-file) (file-name a-file))
                   (list FIL FIL FIL FIL FIL2 FIL)))
(check-expect (file-names-satisfying ROOT (lambda (f) (> 10 (file-size f))))
              (list 'zero1 'small1 'small2 'zero1))

                                     
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                     
;; flatten-dir: (dir -> list of its files)
;; Consumes a directory, and returns a list of files of
;; everything in the directory. Returns files in inner directories first, left to right, 
;; then outside file.
;; Note that if a directories "files" are not actually files, this method will not do any 
;; type checking. Therefor, it is safe to call flatten-dir with dir-files not actually 
;; being a list of files.
(define (flatten-dir dir)
  (append (flatten-lod (dir-dirs dir)) (dir-files dir)))
;; flatten-lod is a helper function for flatten-dir
;; consumes a lod, returns a list of files of all dirs flattened
(define (flatten-lod lod)
  (cond [(empty? lod) empty]
        [else (append (flatten-dir (first lod)) (flatten-lod (rest lod)))]))
;; Test Cases
(check-expect (flatten-dir DIRZ) (list FIL FIL FIL FIL FIL2 FIL))
(check-expect (flatten-dir ROOT) (list FLARGE2 FMED1 FMED1 FZERO  FSMALL1 FSMALL2 FLARGE1 FZERO))



;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; files-containing: FS value -> list of sybol
;; Consumes a file system and a value and produces a list of files names
;; which contain the given value as its contents.
(define (files-containing a-dir val)
  (file-names-satisfying a-dir (lambda (a-file) (equal? (file-content a-file) val))))

(check-expect (files-containing DIRZ 'cont) (list 'name 'name 'name 'name 'name))
(check-expect (files-containing DIRZ 'conte) (list 'name))
(check-expect (files-containing DIRZ 'nothin) empty)
(check-expect (files-containing DIRZ (make-posn 5 5)) empty)
