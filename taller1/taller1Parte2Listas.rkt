#lang eopl
;ERICK LOPEZ PACHECO, 201430406
;JESUS ALBERTO RAMIREZ, 201422554
;LUIS GERARDO MANRIQUE CARDONA, 201327951

;GRAMATICA DE EL ARBOL NARIO
;arboln-ario := (vacio) empty
;:= (hoja) numero
;:= (nodo) numero (list-of-arbol-nario)
;list-of-arbol-nario := (arbol-nario)+
;


;Definicion del tipo de dato arbol nario
(define vacio  'vacio)

(define hoja (lambda (numero)
               (if (number? numero) (list numero) (eopl:error "valor esperado tipo numerico, ingresado: " numero))))

(define nodo (lambda (numero lista-arboles-narios)
               (cond
                 ((not (number? numero)) (eopl:error "valor esperado tipo numerico, ingresado: "numero))
                 ((not (list? lista-arboles-narios)) (eopl:error "valor esperado tipo lista" ))
                 (else
                  (list numero lista-arboles-narios)
                  
                 )
                 )
               )
  )
;Predicados de arbolnario
(define vacio? (lambda (x)
                 (if (eq? x 'vacio) #t #f)
                 )
  )
(define arbol-hoja? (lambda (x)
                 (if (and (number? (car x)) (null? (cdr x))) #t #f)
                 )
  )
(define arbol-nodo? (lambda (x)
                 (if (and (number? (car x)) (list? (cdr x))) #t #f)
                 )
  )
;extractores de arbolnario
(define arbol>numero (lambda (x)
                      (car x)
                      )
  )

(define extraer-lista-arboles (lambda (x)
                                (cadr x)
                                )
  )
(define arbol1
      (nodo
           3
            (list
             (nodo 
              1
              (list
              (nodo
               2088888
               (list
                (hoja 5002)
                (hoja 20)
                (hoja 50)
                )
               )
              )
              )
             (nodo
              7
              (list
               vacio
               (hoja 1)
               (hoja 20)
               (hoja 40)
               (hoja 109)
               (nodo
                108
                (list
                 (hoja 20888882)
                 )
                
                )
               (hoja 90)
               )
              )
             (hoja 20888881)
        )
            )
  )



;Función que extrae recorre una slist de arboles y apoyada con extraer-valores
; retornan una lista con los valores de cada lista de la slist
;slist-arboles -> list
(define extraer-valores-slist (lambda (lista-arboles)
                      (cond
                      ((null? lista-arboles) '())
                      (else (append (extraer-valores (car lista-arboles))  (extraer-valores-slist (cdr lista-arboles))))
                      )
                        )
  )

  
                         
                      
;Función que haciendo llamados recursivos y siendo llamada recursivamente de extraer-valores-slist
;da como resultado una lista con todos los valores de los nodos y hojas de un arbol
;arbol->lista de valores arbol
                      
(define extraer-valores (lambda (arbol)
                    (cond
                      ((vacio? arbol)  (list 0))
                      ((arbol-hoja? arbol)  arbol)
                      ((arbol-nodo? arbol)  (cons (arbol>numero arbol) (extraer-valores-slist (extraer-lista-arboles arbol))  ))
                      )
                    )
  )
;Función que retorna el maximo valor de una lista de datos numerica
;list->maximo-list
(define max-list (lambda (l )
                   (if (null? l)  0
                       (max (car l) (max-list (cdr l))))
                   )
  )
;Funcion que retorna el maximo valor que esta albergado entre todos los nodos y hojas de un arbol
;arbol->maximo-valor-arbol
(define max-arbol (lambda (arbol)
                (max-list  (extraer-valores arbol1))
                    )
  )
;pruebas
(max-arbol arbol1)
