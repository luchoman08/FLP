#lang eopl

;PUNTO 1

;Función que cálcula el tamaño de una lista
;lista -> número
(define longitud (lambda (lista) (length lista)))

;Función que convierte un número a una cadena
;número | lista -> string
(define convertir-a-string (lambda (x)
                                    (if (number? x) (number->string x)
                                        (number->string (longitud x)))))
;Función que compara dos número
;número número símbolo -> booleano
(define comparar (lambda (x y simbolo)
                   (simbolo x y)))

;Función que extrae el primer elemento de una lista
;lista -> any
(define primero (lambda (lista) (car lista)))

;Función que extrae el resto de una lista
;lista -> any
(define resto (lambda (lista) (cdr lista)))

;Función que retorna el elemento de una lista según la posición dada.
;lista -> número | string
(define elementoN-lista (lambda (lista posicion)
                          (cond ((comparar posicion 0 =) (primero lista))
                                ((comparar posicion 0 <) (string-append "elementoN-lista: Usted ha ingresado un argumento inválido: " (convertir-a-string posicion)))
                                ((comparar posicion (longitud lista) >=) (string-append "elementoN-lista: La lista sólo tiene " (convertir-a-string lista) " elementos, no se puede encontrar el elemento en la posición: " (convertir-a-string posicion)))
                                (else (elementoN-lista (resto lista) (- posicion 1))))))

(display (elementoN-lista (list 1 2 3 4) 3))
(display "\n")
(display (elementoN-lista (list 1 2 3 4) -1))
(display "\n")
(display (elementoN-lista (list 1 2 3 4) 4))
