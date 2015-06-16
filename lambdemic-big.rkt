#lang racket

(require pict
         images/icons/style
         images/icons/symbol
         images/icons/misc
         file/convertible)

(define lambda-phage
  (pict->bitmap
   (cc-superimpose
    (bitmap (regular-polygon-icon 6 
                                  (* -1/2 (- (/ pi 6) (* 1/2 pi)))
                                  #:color "darkred"
                                  #:height 256 
                                  #:material glass-icon-material))
    (bitmap (lambda-icon #:height (* 256 3/4) 
                         #:color "white"
                         #:material plastic-icon-material)))))

(send lambda-phage save-file "lambdemic-big.png" 'png)
