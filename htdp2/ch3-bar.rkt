;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ch3-bar) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")))))
; constants
(define MAX-HAPPY 100)
(define BAR-W 100)
(define BAR-H 25)
(define BAR (rectangle BAR-W BAR-H "outline" "black"))

; Happiness is a Number
; represents the current state of bar out of 10

; Happiness -> Happiness
; main loop for the bar
(define (main h)
  (big-bang h
            [on-tick get-sad]
            [on-key cheer-up]
            [to-draw mood]))

; Happiness -> Happiness
; decrements the current happiness unless already 0
(define (get-sad h)
  (cond
    [(<= h 0.0) 0.0]
    [(> h MAX-HAPPY) MAX-HAPPY]
    [else (- h 0.1)]))

; Happiness KeyEvent -> Happiness
; Takes the key event, and on up or down arrow, increments Happiness
(define (cheer-up h ke)
  (cond 
    [(string=? ke "up") (+ h (/ MAX-HAPPY 3))]
    [(string=? ke "down") (+ h (/ MAX-HAPPY 5))]
    [else h]))

; Happiness -> Image
; Draws the bar based on the current state of Happiness
(define (mood h)
  (overlay/align "left" "top" BAR (rectangle h BAR-H "solid" "red")))