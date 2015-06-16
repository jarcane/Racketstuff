;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ch3-car-sine) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")))))
(define WIDTH-OF-WORLD 200)
(define HEIGHT-OF-WORLD 40)
(define BACKGROUND (empty-scene WIDTH-OF-WORLD HEIGHT-OF-WORLD))
(define TREE-LOC (/ WIDTH-OF-WORLD 2))

(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 3))

(define WHEEL (circle WHEEL-RADIUS "solid" "black"))
(define SPACE (rectangle WHEEL-DISTANCE WHEEL-RADIUS "solid" "white"))
(define BOTH-WHEELS (beside WHEEL SPACE WHEEL))

(define BODY-OF-CAR (rectangle (+ (* 2 WHEEL-RADIUS)(image-width BOTH-WHEELS))
                               (* 2 WHEEL-RADIUS)
                               "solid" "red"))
(define PASSENGER-COMPARTMENT (rectangle (image-width SPACE)
                                         (* 3 WHEEL-RADIUS) "solid" "red"))
(define CAR (overlay/offset (overlay/align "center" "bottom"
                                           PASSENGER-COMPARTMENT
                                           BODY-OF-CAR)
                            0 WHEEL-RADIUS
                            BOTH-WHEELS))
(define Y-CAR (- HEIGHT-OF-WORLD (image-height CAR)))

(define tree (underlay/xy (circle 10 'solid 'green)
                          9 15
                          (rectangle 2 20 'solid 'brown)))

; AnimationState is a Number
; interpretation the number of clock ticks since the animation began

; WorldState -> Image
; places the image of the car x pixels from the left margin of 
; BACKGROUND image
(define (render as)
    (place-image tree TREE-LOC (- HEIGHT-OF-WORLD (/ (image-height tree) 2))
                 (place-image CAR as (+ Y-CAR (* 4 (sin (* 1/4 as)))) BACKGROUND)))

; WorldState -> WorldState
; adds 3 to x to move the car right
(define (tock as)
  (+ as 1))
(check-expect (tock 20) 21)
(check-expect (tock 78) 79)

; WorldState -> Boolean
; Returns #t if CAR passes out of sight
(define (end? as)
  (> as (+ WIDTH-OF-WORLD (/ (image-width CAR) 2))))

; WorldState -> WorldState
; launches the program from some initial state
(define (main as)
  (big-bang as
            [on-tick tock]
            [to-draw render]
            [stop-when end?]))