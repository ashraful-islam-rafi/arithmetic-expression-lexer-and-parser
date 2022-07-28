#lang racket

(provide lex)

(require parser-tools/lex)
(require (prefix-in : parser-tools/lex-sre))

(define-lex-abbrev digits (:+ (char-set "0123456789")))
(define-lex-abbrev char-smaller-case (:+ (char-range #\a #\z)))
(define-lex-abbrev char-upper-case (:+ (char-range #\A #\Z)))
(define-lex-abbrev arithmatic-symbols (:or #\+ #\* #\- #\/ #\^))
(define-lex-abbrev left-paren #\()
(define-lex-abbrev right-paren #\))

(define left-paren-tkn (list 'LP))
(define right-paren-tkn (list 'RP))

(define lex
  (lexer
   ; ignoring whitespaces and newlines
   [whitespace (lex input-port)]
    
   ; if digits from 0 to 9
   [digits 
    (list 'Int (string->number lexeme))]
    
   ; if decimal digits
   [(:or (:seq (:? digits) "." digits)(:seq digits "."))
    (list 'Dec (string->number lexeme))]
    
   ; if any character 
   [(:or char-smaller-case char-upper-case)
    (list 'Char (string->symbol lexeme))]
    
   ; if arithmatic symbol
   [arithmatic-symbols
    (list 'Sym (string->symbol lexeme))]
    
   ; if left paren
   [left-paren left-paren-tkn]
    
   ; if right paren 
   [right-paren right-paren-tkn]
    
   ; returning 'EOF on eof
   [(eof) (list 'EOF)]))

