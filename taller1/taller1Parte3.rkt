
#lang eopl
;ERICK LOPEZ PACHECO, 201430406
;JESUS ALBERTO RAMIREZ, 201422554
;LUIS GERARDO MANRIQUE CARDONA, 201327951


;Gramaticas utilizadas

;operacion := (caso1) operador numero numero
;          := (caso2) operador operacion operacion
;          := (caso3) operador numero operacion
;          := (caso4) operador operacion numero

;operador := (suma) "+"
;         := (resta) "-"
;         := (mult) "*"
;         := (div) "/"

;definicion de operacion
; (define caso1
;   (lambda (operador numero numero2) (list operador numero numero2))
;   )
; 
; (define caso2 
;   (lambda (operador operacion1 operacion2) (list operador operacion1 operacion2))
;   )
; 
; (define caso3 
;   (lambda (operador numero operacion) (list operador numero operacion))
;   )
; 
; (define caso4 
;   (lambda (operador operacion numero) (list operador operacion numero))
;   )


;operador
; (define suma
;   (lambda () "+")
;   )
; 
; (define resta
;   (lambda () "-")
;   )
; 
; (define mult
;   (lambda () "*")
;   )
; 
; (define div
;   (lambda () "/")
;   )
; 

(define op1
  (list "+" (list "-" 2 3) (list "+" 4 2)))

(define op2
  (list "+" 4 (list "+" 4 (list "/" 10 2))))



;definicion abstracta
;operador
(define-datatype operador operador?
  (suma)
  (resta)
  (mult)
  (div)
  )

;operacion
(define-datatype operacion operacion?
  (caso1  
   (operador1 operador?)        
   (numero1 number?)        
   (numero2 number?))
  (caso2 
   (operador operador?)
   (operacion1 operacion?)
   (operacion2 operacion?))
  (caso3 
   (operador operador?)        
   (numero number?)       
   (operacion operacion?))
  (caso4 
   (operador operador?)        
   (operacion operacion?)        
   (numero number?))
  )


;;Proposito:
;;Procedimiento que recive una exprecion en sintanxis concreta y retorna
;;la exprecion en sintaxis abstracta
(define parse-operacion-exp
  (lambda (entrada)
    (if (and (string? (car entrada)) (number? (cadr entrada)) (number? (caddr entrada)))
        (cond 
          ((eqv? (car entrada) "+")   (caso1 (suma) (cadr entrada) (caddr entrada)))
          ((eqv? (car entrada) "-")   (caso1 (resta) (cadr entrada) (caddr entrada)))
          ((eqv? (car entrada) "*")   (caso1 (mult) (cadr entrada) (caddr entrada)))
          ((eqv? (car entrada) "/")   (caso1 (div) (cadr entrada) (caddr entrada))) 
          )
        (if (and (string? (car entrada)) (list? (cadr entrada)) (list? (caddr entrada)))
            (cond 
              ((eqv? (car entrada) "+")   (caso2 (suma) (parse-operacion-exp (cadr entrada)) (parse-operacion-exp (caddr entrada))))
              ((eqv? (car entrada) "-")   (caso2 (resta) (parse-operacion-exp (cadr entrada)) (parse-operacion-exp (caddr entrada))))
              ((eqv? (car entrada) "*")   (caso2 (mult) (parse-operacion-exp (cadr entrada)) (parse-operacion-exp (caddr entrada))))
              ((eqv? (car entrada) "/")   (caso2 (div) (parse-operacion-exp (cadr entrada)) (parse-operacion-exp (caddr entrada))))
              )
            (if (and (string? (car entrada)) (number? (cadr entrada)) (list? (caddr entrada)))
                (cond 
                  ((eqv? (car entrada) "+")   (caso3 (suma) (cadr entrada) (parse-operacion-exp (caddr entrada))))
                  ((eqv? (car entrada) "-")   (caso3 (resta) (cadr entrada) (parse-operacion-exp (caddr entrada))))
                  ((eqv? (car entrada) "*")   (caso3 (mult) (cadr entrada) (parse-operacion-exp (caddr entrada))))
                  ((eqv? (car entrada) "/")   (caso3 (div) (cadr entrada) (parse-operacion-exp (caddr entrada)))) 
                  )
                (if (and (string? (car entrada)) (list? (cadr entrada)) (number? (caddr entrada)))
                    (cond 
                      ((eqv? (car entrada) "+")   (caso4 (suma) (parse-operacion-exp (cadr entrada)) (caddr entrada)))
                      ((eqv? (car entrada) "-")   (caso4 (resta) (parse-operacion-exp (cadr entrada)) (caddr entrada)))
                      ((eqv? (car entrada) "*")   (caso4 (mult) (parse-operacion-exp (cadr entrada)) (caddr entrada)))
                      ((eqv? (car entrada) "/")   (caso4 (div) (parse-operacion-exp (cadr entrada)) (caddr entrada))) 
                      )
                    (eopl:error "invalid syntax ~s" entrada))))
        
        )
    
    )
  )

;;Pruebas
(parse-operacion-exp (list "+" 4 (list "+" 4 (list "/" 10 2))))
(parse-operacion-exp op1)


;;Proposito
;;Procedimiento que recive una exprecion en sintaxis abstracta y 
;;devuelve la misma exprecion en sintaxis concreta
(define unparse-operacion-exp 
  (lambda (entrada)
    
    (if (operacion? entrada)
        (cases operacion entrada
          (caso1 (operador numero1 numero2)
                 (list (unparse-operacion-exp operador) numero1 numero2))
          (caso2 (operador operacion1 operacion2) 
                 (list (unparse-operacion-exp operador)(unparse-operacion-exp operacion1) (unparse-operacion-exp operacion2)))
          (caso3 (operador numero operacion)
                 (list (unparse-operacion-exp operador) numero (unparse-operacion-exp operacion)))
          (caso4 (operador operacion numero)
                 (list (unparse-operacion-exp operador)(unparse-operacion-exp operacion) numero))
          )
        (if (operador? entrada)
            (cases operador entrada
              (suma () "+")
              (resta () "-")
              (mult () "*")
              (div () "/")
              )
            (eopl:error "invalid abstrac-syntax ~s" entrada)
            )
        )

    )
  )

;;Pruebas 
(unparse-operacion-exp (parse-operacion-exp op1))
(unparse-operacion-exp (parse-operacion-exp op2))
