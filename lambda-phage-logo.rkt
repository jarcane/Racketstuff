#lang racket

(require pict
         images/icons/style
         images/icons/symbol
         images/icons/misc
         file/convertible)

(define ORIGINAL (list "darkred" 
                       glass-icon-material 
                       "darkslategray"
                       plastic-icon-material))

(define SIDES 7)

(define (lambda-phage phage-color 
                      phage-material
                      lambda-color
                      lambda-material)
  (pict->bitmap
   (cc-superimpose
    (bitmap (regular-polygon-icon SIDES 
                                  (* -1 (- (/ pi SIDES) (* 1/2 pi)))
                                  #:color phage-color
                                  #:height 128 
                                  #:material phage-material))
    (bitmap (lambda-icon #:height 96 
                         #:color lambda-color
                         #:material lambda-material)))))

(send (apply lambda-phage ORIGINAL) 
      save-file "lambda-phage.png" 'png)

(apply lambda-phage ORIGINAL) 