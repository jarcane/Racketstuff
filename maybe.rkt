#lang racket

(require racket/match)

(struct maybe () #:transparent)
(struct none maybe () #:transparent)
(struct some maybe (val) #:transparent)

(define (>>= opt fn)
  (match opt
    [(none) (none)]
    [else (fn (some-val opt))]))

(define-syntax mdo
  (syntax-rules (= <-)
    [(_ (exp ...)) (exp ...)]
    [(_ (name = val) exp ...)
     (>>= (some val) (lambda (name) (mdo exp ...)))]
    [(_ (name <- val) exp ...)
     (>>= val (lambda (name) (mdo exp ...)))]))

(define (// x y)
  (mdo
   (a <- x)
   (b <- y)
   (if (zero? b)
       (none)
       (/ a b))))

(// (some 5) (some 0))
(// (some 5) (some 2))