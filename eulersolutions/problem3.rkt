#lang racket

(require math/number-theory)

(first (sort (filter prime? (flatten (factorize 600851475143))) >))

(first (sort (flatten (factorize 600851475143)) >))