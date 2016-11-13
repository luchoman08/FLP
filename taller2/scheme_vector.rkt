#lang eopl
(require data/gvector)
; Funcion que retorna el tamaño de un gvector
; gvector->int
(define gvector-length (lambda (gv)
                         (vector-length (gvector->vector gv))
                         )
  )

(define scheme-value? (lambda (v) #t))
; definición del tipo de dato ambiente
; environment := <empty-env>
;             := <extended-env-record> (syms vals extend-from)
(define-datatype environment environment?
  (empty-env-record)
  (extended-env-record (syms  gvector?)
                       (vals  gvector?)
                       (extend-from integer?)))
; definicion de macroambiente
; macroambiente := <empty-env> <extended-env-record> <extended-env-record>*
;                  macroambiente (ambiente-vacio ambiente-global ambientes-locales)
(define macroambiente (gvector (empty-env-record) (extended-env-record (gvector ) (gvector) 0)))

; Funcion que devuelve el ambiente numero n del macroambiente inicial
; si se se ingresa un n mayor a la longitud de macroamb da una exepcion
; macroambiente -> ambiente
(define get-env-n (lambda (n)
                (if (> n (- (gvector-length macroambiente) 1))
                    (eopl:error "El ambiente solicitado no existe")
                    (gvector-ref macroambiente n)
                    )
                )
  )


                       
; Funcion que valida si una posicion n dada es valida en un ambiente 
; environmetn positive-integer -> bool
(define posicion-valida-en-ambiente (lambda (env n)
                                           (if  ( > n (- (gvector-length env) 1)) #f #t)
                                           )
  )

; Funcion que valida si una posicion n dada es valida en el macroambiente
; positive-integer->bool
(define posicion-valida-en-macroambiente (lambda (n)
                                            (posicion-valida-en-ambiente macroambiente n)
                                           )
  )

; Funcion que recibe un gvector y un simbolo, si este existe retorna su posicion en el gvector
; si no existe retorna 666 (esto limita a un ambiente a tener menos de 666 variables)
(define search-symbol-gvector (lambda(gv symb pos)
                                (cond
                                  ((not (posicion-valida-en-ambiente gv pos)) 666)
                                  ((eq? (gvector-ref gv pos) symb) pos)
                                  (else (search-symbol-gvector gv symb (+ pos 1)))
                                  )
                                )
  )
; Funcion que recibe un ambiente, busca si existe una variable dada en este y retorna su pocición, si no la encuentra
; retorna -1
; env->posicion
(define search-var (lambda (env var)
  (cases  environment env
    (empty-env-record () (eopl:error "no se ha definido la variable"))
    (extended-env-record (syms vals extend-from)
                         (search-symbol-gvector syms var 0)
                         )
    )
                     )
  )

; Funcion que recibe un ambiente y un identificador de variable y retorna el valor que corresponde a esta, buscando tanto en el ambiente
; ingresado como en los ambientes de los que este extienda
; ambiente y simbolo -> valor
(define apply-env (lambda (env sym)
                    (cases  environment env
                      (empty-env-record () (eopl:error "no se ha definido la variable"))
                      (extended-env-record (syms vals extend-from)
                                           (cond
                                             ((= (search-symbol-gvector syms sym 0) 666) (apply-env (get-env-n extend-from) sym))
                                             (else (gvector-ref vals (search-symbol-gvector syms sym 0)))
                                           )
                                           )
                      )
                    )
  )

; Funcion que chequea si una variable con nombre (id) ya ha sido definida en un ambiente, o en cualquiera de los ambientes de la qeu
; este extienda
; env id -> bool
(define exist-var? (lambda (env sym)
                    (cases  environment env
                      (empty-env-record () #f)
                      (extended-env-record (syms vals extend-from)
                                           (cond
                                             ((= (search-symbol-gvector syms sym 0) 666) (exist-var? (get-env-n  extend-from) sym))
                                             (else #t)
                                           )
                                           )
                      )
                    )
  )
  


; Funcion que retorna el ambiente donde se definen las variables globales del programa

(define get-global-env (lambda()
                         (gvector-ref macroambiente 2)
                         )
  )
; Variable que define la posicion del ambiente global en el macroambiente

(define pos-global-env 1)
; Funcion que adiciona una variable en un ambiente dado, basado en la posicion del ambiente
; en el vector de ambientes (macroambiente)
(define add-var (lambda (pos-env id val)
                  (if (posicion-valida-en-macroambiente pos-env)
                      (cases environment (gvector-ref macroambiente pos-env)
                        (empty-env-record () (eopl:error "algo malo esta pasando, muy malo"))
                        (extended-env-record (syms vals extend-from)
                                             (begin
                                               (gvector-add! vals   val)
                                               (gvector-add! syms id)
                                               )
                                             )
                        )
                      (eopl:error "el ambiente al que se intenta referenciar no existe")
                      )
                  )
  )
; Funcion qeu adiciona una variable a un ambiente que se encuentra en una posicion dada (pos-env)
; si la variable denotada por el id ingresado ya existe
; se modifica esta por el valor de val;

(define set-var (lambda (pos-env id val)
                  (cases environment (get-env-n  pos-env)
                    (empty-env-record () (eopl:error "algo malo esta pasando, muy malo"))
                    (extended-env-record (syms vals extend-from)
                                         (if (exist-var? (get-env-n  pos-env) id)
                                             (gvector-set! vals (search-var (get-env-n   pos-env) id) val)
                                             (add-var pos-env id val)
                                             )
                                         )
                    )
                         )
  )


; Funcion que adiciona una variable global, si la variable denotada por el id ingresado ya existe
; se modifica esta por el valor de val
(define set-var-global (lambda (id val)
                         (set-var pos-global-env id val)
                         )  )
(gvector-add! macroambiente (extended-env-record (gvector 'x 'y 'z) (gvector 1 23 58 ) 1) (extended-env-record (gvector 'x 'y ) (gvector 1 23) 2)
(extended-env-record (gvector 'x 'z ) (gvector 1 23) 2)
              )
(display macroambiente)
;(newline)
(display (get-env-n  3))
(newline)
(display (search-var (get-env-n 2) 'z))
(newline)
(set-var-global  'r 5)
(newline)
(display (search-symbol-gvector (gvector 'z 'x 'y) 'zr 0))
(newline)
(display (get-env-n  2))
(newline)
(display (apply-env  (get-env-n  2)  'r))