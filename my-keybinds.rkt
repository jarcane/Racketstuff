#lang s-exp framework/keybinding-lang

(define (rebind key command)
  (keybinding
   key
   (λ (ed evt)
     (send (send ed get-keymap) call-function
           command ed evt #t))))

;(keybinding "tab" (λ (editor event) (send editor auto-complete)))
;(keybinding "å" (λ (editor event) (send editor insert non-clever-square-bracket)))
;(keybinding "c:l" (λ (editor event) (send editor insert-lambda-template)))

(rebind "tab" "auto-complete")
(rebind "å" "maybe-insert-[]-pair-maybe-fixup-[]")
(rebind "c:l" "insert-lambda-template")
