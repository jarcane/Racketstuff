#lang racket

(require pict
         pict/code
         file/convertible)

(define define-universe  
  (pict->bitmap
   (cc-superimpose 
    (colorize (filled-rounded-rectangle  1500 500) "Moccasin")
    (parameterize ([current-code-font "Envy Code R"]
                   [get-current-code-font-size (lambda () 48)])
      (code (begin
              (define universe
                (void))))))))

(send define-universe
      save-file "define-universe.png" 'png)