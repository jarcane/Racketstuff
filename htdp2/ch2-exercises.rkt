;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ch2-exercises) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor mixed-fraction #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")))))
(define (from-origin x y)
  (sqrt (+ (sqr x) (sqr y))))

(define (cube-volume x)
  (expt x 3))

(define (cube-surface x)
  (* 6 (sqr x)))

(define (string-first string)
  (substring string 0 1))

(define (string-last string)
  (substring string (sub1 (string-length string))))

(define (bool-imply b1 b2)
  (or (and b1 false) (and b2 true)))

(define (image-area image)
  (* (image-height image) (image-width image)))

(define (image-classify image)
  (cond
    [(> (image-height image) (image-width image)) "tall"]
    [(> (image-width image) (image-height image)) "wide"]
    [(= (image-height image) (image-width image)) "square"]))

(define (string-join s1 s2)
  (string-append s1 "_" s2))

(define (string-insert str i)
  (if (zero? (string-length str))
      "_"
      (string-append (substring str 0 i) "_" (substring str i))))

(define (string-delete str i)
  (if (zero? (string-length str))
      ""
      (string-append (substring str 0 i) (substring str (add1 i)))))