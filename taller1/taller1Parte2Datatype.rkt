#lang eopl

; entrada: lista salida: lista en orden contrario
(define elementoN-lista (lambda (lista posicion)
                          (cond
                            ((= posicion 0) (car lista))
                            (else
                             (elementoN-lista (cdr lista) (- posicion 1))
                             )
                            )
                          )
  )
(define-datatype arbol arbol?
  (vacio)
  (hoja (numero number?))
  (nodo (numero number?) (lista-arboles list?))
  )

(define arbol1 (nodo
                10
                (list
                 (nodo
                  5
                  (list
                   (nodo
                    3
                    (list
                     (hoja 1)
                     (hoja 4)
                     )
                    )
                   (nodo
                    7
                    (list
                     (vacio)
                     (hoja 9)
                     )
                    )
                   ))
                 (nodo
                  15
                  (list
                   (hoja 14)
                   (nodo
                    17
                    (list
                     (hoja 16)
                     (hoja 20)
                     )
                    )
                   )
                  )
                 )
                )
  )

                   
  (define arbol2 (nodo
                  10
                  (list
                   (nodo
                    5
                    (list
                     (hoja 3)
                     (hoja 7)
                     )
                    )
                   (nodo
                    12
                    (list
                     (hoja 11)
                     (hoja 15)
                     )
                    )
                   )
                  )
    )

                   
                  

(define recorrido-lista-arboles-preorden(lambda (lista-arboles)
                                 (cond
                                  ((null? lista-arboles) '())
                                  (else
                                   (append (recorrido-preorden (car lista-arboles)) (recorrido-lista-arboles-preorden (cdr lista-arboles)))
                                   )
                                  )
                                 )
  )
                                            
                                          

(define recorrido-preorden (lambda (arbol1)
                            (cases arbol arbol1
                              (vacio () '())
                              (hoja (numero) (list numero ))
                              (nodo (numero lista-arboles)
                               (cons numero (recorrido-lista-arboles-preorden lista-arboles))
                               )
                              )
                             )
  )
(define recorrido-lista-arboles-postorden(lambda (lista-arboles)
                                 (cond
                                  ((null? lista-arboles) '())
                                  (else
                                   (append (recorrido-postorden (car lista-arboles)) (recorrido-lista-arboles-postorden (cdr lista-arboles)))
                                   )
                                  )
                                 )
  )
             
                                     
(define recorrido-postorden (lambda (arbol1)
                            (cases arbol arbol1
                              (vacio () '())
                              (hoja (numero) (list numero))
                              (nodo (numero lista-arboles)
                               (append  (recorrido-lista-arboles-postorden lista-arboles)  (list numero ))
                               )
                              )
                             )
  )   
(define recorrido-inorden (lambda (arbol1)
                            (cases arbol arbol1
                              (vacio () '())
                              (hoja (numero) (list numero))
                              (nodo (numero lista-arboles)
                               (append  (recorrido-lista-arboles-postorden lista-arboles)  (list numero ))
                               )
                              )
                             )
  )  
(define arbol3(nodo
               1
               (list
                (nodo 
                 2
                 (list
                  (hoja 4)
                  (hoja 5)
                  )
                 )
                (nodo
                 3
                 (list
                  (hoja 6)
                  (hoja 7)
                  )
                 )
                )
               )
  )
(define arbol4 (nodo
                10
                (list
                 (nodo
                  5
                  (list
                   (hoja 3)
                   (hoja 7)
                   )
                  )
                 (nodo
                  12
                  (list
                   (hoja 11)
                   (hoja 15)
                   )
                  )
                 )
                )
  )
                 
             
                 
                
                
(display (recorrido-preorden arbol1))
(newline)
(display (recorrido-postorden arbol1))
(newline)
(display (recorrido-inorden arbol4))

