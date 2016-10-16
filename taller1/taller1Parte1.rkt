#lang eopl
;ERICK
;JESUS 
;LUIS GERARDO MANRIQUE CARDONA, 201327951

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

;;;;;;;;;;;;;;;;PUNTO 3;;;;;;;;;;;;;;;;;                              

(define valor-arbol (lambda (x) (car x)))
(define arbol-izquierdo (lambda (x) (cadr x)))
(define arbol-derecho (lambda (x) (caddr x)))
(define hoja? (lambda (x) (number? x)))

(define insertar-arbolbinariobusqueda (lambda (arbol valor)
                                        (cond
                                          ((empty? arbol)  (list valor empty empty ))
                                          ((hoja? arbol)
                                           (cond
                                             ((> valor arbol) (list arbol  empty valor))
                                             (else (list arbol valor empty))
                                                   )
                                           )
                                          (else
                                           (cond 
                                             ((> valor (valor-arbol arbol)) (list  (valor-arbol arbol) (arbol-izquierdo arbol) (insertar-arbolbinariobusqueda (arbol-derecho arbol) valor)))
                                             ((<= valor (valor-arbol arbol)) (list  (valor-arbol arbol)  (insertar-arbolbinariobusqueda (arbol-izquierdo arbol) valor) (arbol-derecho arbol)))
                                             )
                                           )
                                          )
                                        )
  )


;;;;;;;;;;;;;PRUEBAS PUNTO 3;;;;;;;;;;;;;;;;;;,
(define arbol1  empty )
(display arbol1)
(define arbol2 (insertar-arbolbinariobusqueda  arbol1 10))
(newline)
(display arbol2)
(define arbol3 (insertar-arbolbinariobusqueda  arbol2 5))
(newline)
(display arbol3)
(define arbol4 (insertar-arbolbinariobusqueda  arbol3 25))
(newline)
(display arbol4)
(define arbol5 (insertar-arbolbinariobusqueda  arbol4 25))
(newline)
(display arbol5)
(define arbol6 (insertar-arbolbinariobusqueda  arbol5 26))
(newline)
(display arbol6)
(define arbol7 (insertar-arbolbinariobusqueda  arbol6 2))
(newline)
(display arbol7)
(newline)
(display ( insertar-arbolbinariobusqueda ( list 5 ( list 4 ( list 1 empty empty ) empty ) ( list 7 ( list 6 empty empty ) ( list 13 ( list 12 empty empty ) empty ) ) ) 5))
(newline)
(display (insertar-arbolbinariobusqueda (list 10 empty empty) 10))
                                
                                
;;;;;;;PRUEBAS PROBLEMA 1;;;;;;;;;;;;;;;;;;
;(display (elementoN-lista (list 1 2 3 4) 3))
;(display "\n")
;(display (elementoN-lista (list 1 2 3 4) -1))
;(display "\n")
;(display (elementoN-lista (list 1 2 3 4) 4))


;;;;;;;;;;;;PRUEBAS PROBLEMA 2;;;;;;;;;;;;;;;;;;,
(display (distancia-puntos (list (list 1 2 3 4) (list 4 3 2 1)) linearecta))
(display "\n")
(display (distancia-puntos (list (list 1 2 3 4) (list 4 3 2 1)) manhathan))
(display "\n")
(display (distancia-puntos (list (list 1 2 3 4) (list 3 2 1)) manhathan))  




