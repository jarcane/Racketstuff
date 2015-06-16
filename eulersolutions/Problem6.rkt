#lang racket

(- (expt (for/sum ([i (in-range 1 101)]) i) 2)
   (for/sum ([i (in-range 1 101)]) (expt i 2)))