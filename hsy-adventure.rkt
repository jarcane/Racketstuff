#lang s-exp heresy

(describe room 
          (name "A room.")
          (desc "It is a room.")
          (exits (n s e w)))

(def fn show-room (r)
  (? (head (r 'name)))
  (? (head (r 'desc)))
  (? & "Possible exits are: ")
  (? (head (r 'exits))))