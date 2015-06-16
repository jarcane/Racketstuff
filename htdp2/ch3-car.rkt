;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ch3-car) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")))))
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

; WorldState is a Number
; interpretation the number of pixels between the left border and the car

; WorldState -> Image
; places the image of the car x pixels from the left margin of 
; BACKGROUND image
(define (render ws)
    (place-image tree TREE-LOC (- HEIGHT-OF-WORLD (/ (image-height tree) 2))
                 (place-image CAR ws Y-CAR BACKGROUND)))

; WorldState -> WorldState
; adds 3 to x to move the car right
(define (tock ws)
  (+ ws 3))
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)

; WorldState Number Number String -> WorldState
; places the care at position (x, y)
; if the mouse event is "button-down"
(define (hyper x-position-of-car x-mouse y-mous me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))

; WorldState -> Boolean
; Returns #t if CAR passes out of sight
(define (end? ws)
  (> ws (+ WIDTH-OF-WORLD (/ (image-width CAR) 2))))

; WorldState -> WorldState
; launches the program from some initial state
(define (main ws)
  (big-bang ws
            [on-tick tock]
            [on-mouse hyper]
            [to-draw render]
            [stop-when end?]))