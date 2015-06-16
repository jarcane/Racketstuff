#lang racket

(require racket/stxparam)
(define (list$ l)
  (map string (string->list l)))
(define-syntax-parameter carry #f)
(define-syntax-parameter cry #f)

(define-syntax for
  (syntax-rules (in)
    ((_ (var in lst) body ...)
     (let loop ((cry-v '())
                (l lst))
       (syntax-parameterize
        ([cry (make-rename-transformer #'cry-v)])
        (if (null? l)
            cry-v
            (let ([var (car l)])
              (loop
               (call/ec
                (lambda (k)
                  (syntax-parameterize
                   ([carry (make-rename-transformer #'k)])
                   body ...)
                  cry-v))
               (cdr l)))))))))

(for (x in '(1 2 3 4))
  (carry (cons (* x x) cry)))

(for (x in (list$ "Dave is fat"))
  (if (string=? x "a") x  (carry (if (null? cry) x (string-append cry x)))))