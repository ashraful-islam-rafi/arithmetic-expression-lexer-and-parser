# arithmetic-expression-lexer-and-parser

In this project, I tried to write a basic lexer and parser in `Racket` for arithmetic expression, which can take an arbitrary expression, and keeping the operator precedence in mind, can print the output in LISP and INFIX notation.

I followed the below-mentioned `EBNF` grammar to code this up,
```
; --
; expr     : term [(+ | -) term]*
; term     : factor [(* | /) factor]*
; factor   : exponent [^ factor]*
; exponent : Number | LP expr RP
; --
```

Let's say the expression is, `1 + 2 * 3 - 4 / 2`, the output will be:
```
in LISP notation  : `(- (+ 1 (* 2 3)) (/ 4 2))`
in INFIX notation : `((1 + (2 * 3)) - (4 / 2))`
```

### Example test cases
```
(define case-0 "1 + 2 + 3 + 4 + 5") 
(define case-1 "1 + 2 * 3 - 4 / 2")
(define case-2 "(1+2)*2*6/2-2^2^3-1")  
(define case-3 "2 + 3 * (10.5 / (9 / (3.3 + 1) - 1)) / (2 + 3) - (5) - 3 + 8")
(define case-4 "((2 + 3 * (10.5 / (9 / (3.3 + 1) - 1))) / (2 + 3)) - ((5) - 3 + 8)")
(define case-5 "(2 + 3 * 10.5 / (9 / (3.3 + 1) - 1) / (2 + 3) - 5 - 3 + 8")
(define case-6 "1 - 2 * 3")
```

### Output
```
-----------Lisp Style------------
'(+ (+ (+ (+ 1 2) 3) 4) 5)
'(- (+ 1 (* 2 3)) (/ 4 2))
'(- (- (/ (* (* (+ 1 2) 2) 6) 2) (expt 2 (expt 2 3))) 1)
'(+ (- (- (+ 2 (/ (* 3 (/ 10.5 (- (/ 9 (+ 3.3 1)) 1))) (+ 2 3))) 5) 3) 8)
'(- (/ (+ 2 (* 3 (/ 10.5 (- (/ 9 (+ 3.3 1)) 1)))) (+ 2 3)) (+ (- 5 3) 8))
'(+ (- (- (+ 2 (/ (/ (* 3 10.5) (- (/ 9 (+ 3.3 1)) 1)) (+ 2 3))) 5) 3) 8)
'(- 1 (* 2 3))

-----------Infix Style------------
'((((1 + 2) + 3) + 4) + 5)
'((1 + (2 * 3)) - (4 / 2))
'((((((1 + 2) * 2) * 6) / 2) - (2 expt (2 expt 3))) - 1)
'((((2 + ((3 * (10.5 / ((9 / (3.3 + 1)) - 1))) / (2 + 3))) - 5) - 3) + 8)
'(((2 + (3 * (10.5 / ((9 / (3.3 + 1)) - 1)))) / (2 + 3)) - ((5 - 3) + 8))
'((((2 + (((3 * 10.5) / ((9 / (3.3 + 1)) - 1)) / (2 + 3))) - 5) - 3) + 8)
'(1 - (2 * 3)
```
## How to run
To run the test cases, open the `test.rkt` file. 
The `print-ast` helper function by default prints in `LISP` notation. So, to print in `INFIX` notation, simply pass `infix` as an argument to the `print-ast` function, like below:
```
(print-ast (parse (open-input-string case-0)) "infix")
```



