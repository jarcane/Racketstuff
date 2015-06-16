#lang racket

; Given a File containing a newline-delineated list of English words, find the number of words
; whose individual letters are in alphabetical order. 

; According to the QI episode "Kitsch", there are only three such 6-letter words

; Word -> List
; takes a Word and turns it into a list of that word's characters as 1-char strings.
(define (listify w)
  (map string (string->list w)))

; Word -> Boolean
; Checks a Word and determines whether the letters are in alphabetical order
(define (alphabetic? w)
  (let ([word (string-downcase w)])
    (equal? (listify word) (sort (listify word) string<?))))

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
(define (alphabetic-in-file word-file)
  (for/list ([w (in-lines (open-input-file word-file))]
             #:when (and (alphabetic? w)
                         (real-word? w)))
    w))

; List -> Lists
; Outputs a report containing useful information about the alphabetic list
(define (alpha-report word-file)
  (let ([lst (alphabetic-in-file word-file)])
    (displayln `(Alphabetic words in file: ,(length lst)))
    (displayln `(Longest alphabetic word in file: ,(longest lst)))
    (displayln `(Number of alphabetic words with exactly 6 letters: 
                        ,(length (filter (lambda (s) (= (string-length s) 6)) lst))))
    (displayln `(List of alphabetic words with exactly 6 letters: 
                      ,(filter (lambda (s) (= (string-length s) 6)) lst)))
    (displayln `(Number of alphabetic words with greater than 6 letters: 
                        ,(length (filter (lambda (s) (> (string-length s) 6)) lst))))
    (displayln `(List of alphabetic words with greater than 6 letters: 
                      ,(filter (lambda (s) (> (string-length s) 6)) lst)))
    (displayln `(Number of alphabetic words with greater than 3 letters: 
                        ,(length (filter (lambda (s) (> (string-length s) 3)) lst))))
    ; (displayln `(List of alphabetic words: ,lst))
    ))

;; Sample Output Report 
; Using the file "wordsEn.txt" gained from http://www-01.sil.org/linguistics/wordlists/english/
; (alpha-report "wordsEn.txt") produces the following report:
; (Alphabetic words in file: 544)
;(Longest alphabetic word in file: billowy)
;(Number of alphabetic words with exactly 6 letters: 37)
;(List of alphabetic words with exactly 6 letters: (abbess abbott abhors accent accept access accost adders afflux almost begins begirt bellow bijoux billow biopsy bloops blotty cellos chills chilly chimps chinos chintz chippy chivvy choosy choppy clotty efflux effort floors floppy flossy ghosty glossy knotty))
;(Number of alphabetic words with greater than 6 letters: 2)
;(List of alphabetic words with greater than 6 letters: (beefily billowy))
;(Number of alphabetic words with greater than 3 letters: 351)

; As we can see therefore, there are in fact 37 6-letter alphabetic words, just from this list