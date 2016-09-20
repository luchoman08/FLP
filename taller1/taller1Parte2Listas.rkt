#lang eopl

;;punto 4 -listas
;;Un arbol numerico n-ario presenta la siguiente gramatica:
;;arboln-ario := (vacio) empty
;;:= (hoja) numero
;;:= (nodo) numero (list-of-arbol-nario)

(define vacio (lambda () 'vacio))

(define hoja (lambda (numero) (list numero)))

(define nodo (lambda (numero lista-arboles-narios) (list numero lista-arboles-narios)))

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
            5
            (list
             (nodo 
              1
              (list
               'vacio
               (hoja 11)
               )
              )
             (nodo
              7
              (list
               'vacio
               (hoja 1)
               (hoja 20)
               (hoja 40)
               (hoja 50)
               (nodo
                108
                (list
                 (hoja 41)
                 )
                )
               (hoja 90)
               )
              )
             (hoja 50)
        )
            )
)



(define extraer-valores-slist (lambda (lista-arboles)
                      (cond
                      ((null? lista-arboles) '())
                      (else (append (extraer-valores (car lista-arboles))  (extraer-valores-slist (cdr lista-arboles))))
                      )
                        )
  )

  
                         
                      
                      
                      
(define extraer-valores (lambda (arbol)
                    (cond
                      ((vacio? arbol)  (list 0))
                      ((arbol-hoja? arbol)  arbol)
                      ((arbol-nodo? arbol)  (cons (arbol>numero arbol) (extraer-valores-slist (extraer-lista-arboles arbol))  ))
                      )
                    )
  )
(define max-list (lambda (l )
                   (if (null? l)  0
                       (max (car l) (max-list (cdr l))))
                   )
  )
(define max-arbol (lambda (arbol)
                (max-list  (extraer-valores arbol1))
                    )
  )
(display (max-arbol arbol1))
