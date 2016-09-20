#lang eopl

;PUNTO 2

;Función que compara si la longitud de dos listas es la misma
;lista lista -> booleano
(define comparar (lambda (x y)
                   (if (= (length x) (length y)) #t #f)))

;Función que determina el número de elementos demás en una lista comparada con alguna otra
;lista lista -> número
(define elementos-extra (lambda (x y)
                          (abs (- (length x) (length y)))))

;Función que determina sí una lista tiene más elementos que otra
;lista lista -> lista
(define lista-mayor (lambda (x y)
                    (if (> (length x) (length y)) x y)))

;Función que convierte una lista de número en una cadena
;lista lista -> string
(define convertir-a-string (lambda (x y)
                                    (cond ((null? x) "")
                                          ((and (null? (cdr x)) (> (length y) 1)) (string-append "y " (number->string (car x))))
                                          ((null? (cdr x)) (string-append (number->string (car x))))
                                          ((null? (cddr x)) (string-append (number->string (car x)) " " (convertir-a-string (cdr x) y)))
                                          (else (string-append (number->string (car x)) ", " (convertir-a-string (cdr x) y))))))

;Función que devuelve los elementos extras de una lista
;lista número -> lista
(define elementos (lambda (x numero)
                    (list-tail x (- (length x) numero))))

;Función que ejecuta la siguiente fórmula: (y1-x1)2 + (y2-x2)2 + ... + (yn-xn)2
;lista lista -> número
(define operar (lambda (x y)
                 (if (null? x) 0
                     (+ (expt (- (car y) (car x)) 2) (operar (cdr x) (cdr y))))))

;Función que determina la distancia entre dos puntos utilizando la ecuación de la línea recta
;lista lista -> número
(define linearecta (lambda (x y)
                     (sqrt (operar x y))))

;Función que determina la distancia entre dos puntos utilizando la ecuación Manhathan
;lista lista -> número 
(define manhathan (lambda (x y)
                    (if (null? x) 0
                        (+ (abs (- (car y) (car x))) (manhathan (cdr x) (cdr y))))))

;Función que determina la distancia entre dos puntos ya sea mediante la ecuación de la línea recta o la de Manhathan
;lista símbolo -> número | string
(define distancia-puntos (lambda (lista funcion)
                           (cond ((comparar (car lista) (cadr lista)) (funcion (car lista) (cadr lista)))
                                 ((= 1 (length (elementos (lista-mayor (car lista) (cadr lista)) (elementos-extra (car lista) (cadr lista))))) (string-append "distancia-puntos: los puntos x e y no tienen el mismo tamaño el error está en el dígito " (convertir-a-string (elementos (lista-mayor (car lista) (cadr lista)) (elementos-extra (car lista) (cadr lista))) (elementos (lista-mayor (car lista) (cadr lista)) (elementos-extra (car lista) (cadr lista))))))
                                 (else (string-append "distancia-puntos: los puntos x e y no tienen el mismo tamaño el error está en los dígitos " (convertir-a-string (elementos (lista-mayor (car lista) (cadr lista)) (elementos-extra (car lista) (cadr lista))) (elementos (lista-mayor (car lista) (cadr lista)) (elementos-extra (car lista) (cadr lista)))))))))

;Casos de prueba
(display (distancia-puntos (list (list 1 2 3 4) (list 4 3 2 1)) linearecta))
(display "\n")
(display (distancia-puntos (list (list 1 2 3 4) (list 4 3 2 1)) manhathan))
(display "\n")
(display (distancia-puntos (list (list 1 2 3 4) (list 3 2 1)) manhathan))
