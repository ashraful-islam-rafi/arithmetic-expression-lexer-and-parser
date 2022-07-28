#lang racket

(require "parser.rkt" "lexer.rkt")

;;;;;;; test cases
(define case-0 "1 + 2 + 3 + 4 + 5") 
(define case-1 "1 + 2 * 3 - 4 / 2")
(define case-2 "(1+2)*2*6/2-2^2^3-1")  
(define case-3 "2 + 3 * (10.5 / (9 / (3.3 + 1) - 1)) / (2 + 3) - (5) - 3 + 8")
(define case-4 "((2 + 3 * (10.5 / (9 / (3.3 + 1) - 1))) / (2 + 3)) - ((5) - 3 + 8)")
(define case-5 "(2 + 3 * 10.5 / (9 / (3.3 + 1) - 1) / (2 + 3) - 5 - 3 + 8")
(define case-6 "1 - 2 * 3")

;;;;;;; Run examples
(begin
  (displayln "-----------Lisp Style------------")
  (print-ast (parse (open-input-string case-0)))
  (print-ast (parse (open-input-string case-1)))
  (print-ast (parse (open-input-string case-2)))
  (print-ast (parse (open-input-string case-3)))
  (print-ast (parse (open-input-string case-4)))
  (print-ast (parse (open-input-string case-5)))
  (print-ast (parse (open-input-string case-6)))
  
  (displayln "\n-----------Infix Style------------")
  (print-ast (parse (open-input-string case-0)) "infix")
  (print-ast (parse (open-input-string case-1)) "infix")
  (print-ast (parse (open-input-string case-2)) "infix")
  (print-ast (parse (open-input-string case-3)) "infix")
  (print-ast (parse (open-input-string case-4)) "infix")
  (print-ast (parse (open-input-string case-5)) "infix")
  (print-ast (parse (open-input-string case-6)) "infix"))

; let's test the lexer for a particular expression
; with each call to the lex function, it will return
; the next-token until it hits the EOF
(define input (open-input-string case-0))
(begin
  (displayln "\n-----------Testing lexer------------")
  (lex input)
  (lex input)
  (lex input)
  (lex input)
  (lex input)
  (lex input)
  (lex input)
  (lex input)
  (lex input)
  (lex input))
