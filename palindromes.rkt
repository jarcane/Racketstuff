#lang racket

; Given a File containing a newline-delineated list of English words, 
; Find the number of palindromes

; Word -> List
; takes a Word and turns it into a list of that word's characters as 1-char strings.
(define (listify w)
  (map string (string->list w)))

; Word -> Boolean
; Checks a Word and determines whether the letters are in alphabetical order
(define (palindrome? w)
  (let ([word (string-downcase w)])
    (string=? word (list->string (reverse (string->list word))))))

; Word -> Boolean
; Checks a Word to see if it is a valid word, ie. contains both consonants and vowels
(define (real-word? w)
  (memf (lambda (c) (member c '("a" "e" "i" "o" "u" "y"))) (listify w)))

; String String -> String
; Takes two strings, returns the largest
(define (string-max s1 s2)
  (if (>= (string-length s1) (string-length s2))
      s1
      s2))

; List -> Word
; Finds the longest word in a list of words
(define (longest lst)
  (foldl string-max "" lst))

; Filename -> List
; Iterates over the given file, building a list of words which are alphabetic
(define (palindrome-in-file word-file)
  (for/list ([w (in-lines (open-input-file word-file))]
             #:when (and (palindrome? w)
                         (real-word? w)))
    w))

; List -> Lists
; Outputs a report containing useful information about the alphabetic list
(define (pal-report word-file)
  (let ([lst (palindrome-in-file word-file)])
    (displayln `(Palindromes in file: ,(length lst)))
    (displayln `(Longest palindrome in file: ,(longest lst)))
    (displayln `(Number of palindromes with greater than 6 letters: 
                        ,(length (filter (lambda (s) (> (string-length s) 6)) lst))))
    (displayln `(Number of palindromes with greater than 3 letters: 
                        ,(length (filter (lambda (s) (> (string-length s) 3)) lst))))
    (displayln lst)))

;; Sample Output Report 
; Using the file "wordsEn.txt" gained from http://www-01.sil.org/linguistics/wordlists/english/
; (pal-report "wordsEn.txt") produces the following report:
; (Palindromes in file: 79)
;(Longest palindrome in file: malayalam)
;(Number of palindromes with greater than 6 letters: 5)
;(Number of palindromes with greater than 3 letters: 38)
;(a aha ama ana anna bib bob boob bub civic dad deed deified deled denned dewed did dud eke ere esse eve ewe eye gag gig hah hallah huh ii iii kaiak kayak kook level madam malayalam minim mom mum nan non noon nun oho otto pap peep pep pip poop pop pup radar redder refer reifier reviver rotator rotor sagas sees seres sexes shahs sis solos sos stats stets tat tenet tit toot tot tut wow xix yay)