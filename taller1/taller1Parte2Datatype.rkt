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

(define recorrido-lista-arboles-inorden(lambda (lista-arboles)
                                 (cond
                                  ((null? lista-arboles) '())
                                  (else
                                   (if (pair? lista-arboles)
                                   (append (recorrido-inorden (car lista-arboles)) (recorrido-lista-arboles-inorden (cdr lista-arboles)))
                                   (append (recorrido-inorden lista-arboles))
                                   )
                                   )
                                  )
                                 )
  )

(define recorrido-inorden (lambda (arbol1)
                            (cases arbol arbol1
                              (vacio () '())
                              (hoja (numero) (list numero))
                              (nodo (numero lista-arboles)
                               (append  (recorrido-lista-arboles-inorden (car lista-arboles)) (list numero ) (recorrido-lista-arboles-inorden (cdr lista-arboles)  ))
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
                  18
                  (list    
                   (hoja 19)
                   (hoja 20)
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
                 
             
                 
                
                
(recorrido-preorden arbol1) ;(10 5 3 1 4 7 9 15 14 17 16 20)
(recorrido-postorden arbol4) ;(3 7 5 19 20 18 11 15 12 10)
(recorrido-inorden arbol4) ;(3 5 7 10 19 18 20 11 12 15)
