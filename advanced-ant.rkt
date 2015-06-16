#lang racket

; http://www.reddit.com/r/dailyprogrammer/comments/2c4ka3/7302014_challenge_173_intermediate_advanced/

(require 2htdp/universe
         2htdp/image)

(define possible-colors 
  (list->vector
   (map (λ (c) (apply make-color c))
        '(
          ; base black and white
          (255 255 255 255)
          (  0   0   0 255)
          ; color brewer qualitative 12
          (141 211 199 255)
          (255 255 179 255)
          (190 186 218 255)
          (251 128 114 255)
          (128 177 211 255)
          (253 180  98 255)
          (179 222 105 255)
          (252 205 229 255)
          (217 217 217 255)
          (188 128 189 255)
          (204 235 197 255)
          (255 237 111 255)
          ))))

; structs
(define-struct ant (position direction))
(define-struct world (grid ant size turns))
(define-struct vec2 (x y) #:transparent)

; helpers
(define (vec2-add v1 v2)
  (vec2
   (+ (vec2-x v1)(vec2-x v2))
   (+ (vec2-y v1)(vec2-y v2))))

(define (gen-empty-grid m n)
  (build-vector m (lambda (y) (make-vector n 0))))

(define (gen-initial-world size turns)
  (world (gen-empty-grid size size)
         (ant (vec2 (/ size 2) (/ size 2))
              'N)
         size
         turns))

(define (lookup-state w pos)
  (vector-ref (vector-ref (world-grid w) (vec2-x pos)) (vec2-y pos)))


(define (check-wrap-around xmax ymax pos)
  (cond
    [(> 0 (vec2-x pos)) (vec2 (sub1 xmax) (vec2-y pos))]
    [(> 0 (vec2-y pos)) (vec2 (vec2-x pos) (sub1 ymax))]
    [(<= xmax (vec2-x pos)) (vec2 0 (vec2-y pos))]
    [(<= ymax (vec2-y pos)) (vec2 (vec2-x pos) 0)]
    [else pos]))

(define (tick-current-square! w)
  (match-define (world grid (ant (vec2 x y) _) _ turns) w)
  (define current (vector-ref (vector-ref grid x) y))
  (vector-set! (vector-ref grid y) x 
               (modulo (add1 current) 
                       (vector-length turns))))

(define turn
  (match-lambda**
   ; north
   (['N 'L] 'W)
   (['N 'R] 'E)
   ; west
   (['W 'L] 'S)
   (['W 'R] 'N)
   ; east
   (['E 'L] 'N)
   (['E 'R] 'S)
   ; south
   (['S 'L] 'E)
   (['S 'R] 'W)))

(define (input->turn-vector input-string)
  (list->vector
   (map (compose string->symbol string) (string->list input-string))))


; movement
(define (tick-world! w)
  (define turn-vector (world-turns w))
  (define size (world-size w))
  
  ; look at the direction the ant is facing
  (define movement-modifier
    (case (ant-direction (world-ant w))
      ['N (vec2  0 -1)]
      ['S (vec2  0  1)]
      ['W (vec2 -1  0)]
      ['E (vec2  1  0)]))
      
  ; read the next position
  (define next-pos
    (check-wrap-around size size
                       (vec2-add
                        movement-modifier
                        (ant-position (world-ant w)))))
                        
  ; turn depending on next position
  (define next-direction
    (turn (ant-direction (world-ant w))
          (vector-ref (world-turns w) (lookup-state w next-pos) )))
          
  ; mutate grid in world
  (tick-current-square! w )
  
  ; update position & direction of ant, return world
  (struct-copy world w
               [ant (struct-copy ant (world-ant w) 
                                 [position next-pos]
                                 [direction next-direction])]))

(define (iterate-world w n)
  (if (<= 0 n)
      (iterate-world (tick-world! w) (sub1 n))
      w))

(define (world->pic w)
  (color-list->bitmap 
   (reverse 
    (for/fold ([acc '()])
      ([row (world-grid w)])
      (for/fold ([acc acc])
        ([n row])
        (cons (vector-ref possible-colors n) acc))))
   (world-size w) (world-size w)))

(define (display-world s)
  (lambda (w)
    (scale s (world->pic w))))

(define (main input-string size scale-factor speed-factor)
  (define tick-fn
    (lambda (w) (iterate-world w speed-factor)))
  (if (> (string-length input-string)
         (vector-length possible-colors)) 
      (displayln (~a "String too long. Only " (vector-length possible-colors) " turns allowed."))
      (begin
        (big-bang 
         (gen-initial-world size (input->turn-vector input-string))
         (on-tick tick-fn)
         (on-draw (display-world scale-factor))))))