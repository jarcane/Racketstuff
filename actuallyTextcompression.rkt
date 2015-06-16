#lang racket

(for ((i "Actually it's about ethics in game journalism"))
  (display (integer->char (+ (char->integer i) 47))))

(displayln "")

(for ((i "p£¤¨O£V¢O¤£O£¢OOO¤¡¢"))
  (display (integer->char (- (char->integer i) 47))))