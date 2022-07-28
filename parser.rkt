#lang racket

(provide parse print-ast)

(require "lexer.rkt")

; defining our structure Abstract Syntax Tree (ast) to store the arithmetic exp.
; for example, if the expression is, 1 - 2 * 3
; with operator precedence the correct exp. should be, (1 - (2 * 3))
; we will store the exp. in the tree like below,
; so that operators with higher precedence is lower in the tree!
;      (-)
;     /   \
;   (1)   (*)
;        /   \
;      (2)   (3)
(define-struct ast [left op right])

(define (print-ast a-tree [notation "lisp"])
  (cond
    [(number? a-tree) a-tree]
    [(ast? a-tree)
     (cond
       [(eq? notation "lisp")
        (list
         (ast-op a-tree) 
         (print-ast (ast-left a-tree) notation)
         (print-ast (ast-right a-tree) notation)
         )]
       [else
        (list
         (print-ast (ast-left a-tree) notation)
         (ast-op a-tree)  
         (print-ast (ast-right a-tree) notation)
         )]
       )]))

(define (parse input-exp)
  (define next_tkn (lex input-exp))

  (define (exponent)
    ; exponent : Number | LP expr RP
    
    (match next_tkn
      [(or `(Int ,num) `(Dec ,num))
       (set! next_tkn (lex input-exp))
       num]
      
      [`(LP)
       (set! next_tkn (lex input-exp))
       (define node (expr))
       (set! next_tkn (lex input-exp))
       node]
      
      [_ (error "Error: unknown expression!")]))
  
  (define (factor)
    ; factor   : exponent [^ factor]*
    
    (define node (exponent))
    
    (let loop ([updated_node node])
      (match next_tkn
        [(or '(EOF) '(RP)) updated_node]
        [`(Sym ,symb)
         (match symb
           ['^ (set! next_tkn (lex input-exp))
               (loop (make-ast updated_node 'expt (factor) ))]
        
           [_ updated_node]
           )]
        [_ (error "Error: unknown expression!")])))
  
  

  (define (term)
    ; term : factor ((* | /) factor)*
    
    (define node (factor))

    (let loop ([updated_node node])
      (match next_tkn
        [(or '(EOF) '(RP)) updated_node]
        [`(Sym ,symb)
         (match symb
           ['* (set! next_tkn (lex input-exp))
               (loop (make-ast updated_node symb (factor)))]
           
           ['/ (set! next_tkn (lex input-exp))
               (loop (make-ast updated_node symb (factor)))]
           
           [_ updated_node]
           )]
        [_ (error "Error: unknown expression!")])))

  (define (expr)
    ; --
    ; expr     : term [(+ | -) term]*
    ; term     : factor [(* | /) factor]*
    ; factor   : exponent [^ factor]*
    ; exponent : Number | LP expr RP
    ; --
    
    (define node (term))

    (let loop ([updated_node node])
      (match next_tkn
        [(or '(EOF) '(RP)) updated_node]
        [`(Sym ,symb)
         (match symb
           ['+ (set! next_tkn (lex input-exp))
               (loop (make-ast updated_node symb (term)))]
           
           ['- (set! next_tkn (lex input-exp))
               (loop (make-ast updated_node symb (term)))]
           
           [_ updated_node]
           )]
        [_ (error "Error: unknown expression!")])))
  
  (expr))