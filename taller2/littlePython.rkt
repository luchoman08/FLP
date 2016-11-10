#lang eopl

;******************************************************************************************

;;*******************************Equipo de trabajo********************************
;;-> Erik Lopez Pacheco --- 201430406
;;-> Luis Manrique ---- 201327951
;;-> Jesus Alberto Ramirez ---- 201422554
;;;;; Interpretador para lenguaje con condicionales, ligadura local, procedimientos,
;;;;; procedimientos recursivos, ejecución secuencial y asignación de variables

;; La definición BNF para las expresiones del lenguaje:
;;
;;  <program>       ::= <expression>
;;                      <a-program (exp)>
;;  <expression>    ::= <number>
;;                      <lit-exp (datum)>
;;                  ::= <identifier>
;;                      <var-exp (id)>
;;                  ::= <primitive> ({<expression>}*(,))
;;                      <primapp-exp (prim rands)>
;;                  ::= if <expresion> then <expresion> else <expression>
;;                      <if-exp (exp1 exp2 exp23)>
;;                  ::= let {<identifier> = <expression>}* in <expression>
;;                      <let-exp (ids rands body)>
;;                  ::= proc({<identificador>}*(,)) <expression>
;;                      <proc-exp (ids body)>
;;                  ::= (<expression> {<expression>}*)
;;                      <app-exp proc rands>
;;                  ::= letrec  {identifier ({identifier}*(,)) = <expression>}* in <expression>
;;                     <letrec-exp(proc-names idss bodies bodyletrec)>
;;                  ::= begin <expression> {; <expression>}* end
;;                     <begin-exp (exp exps)>
;;                  ::= set <identifier> = <expression>
;;                     <set-exp (id rhsexp)>
;;  <primitive>     ::= + | - | * | add1 | sub1 

;******************************************************************************************

;******************************************************************************************
;Especificación Léxica
;<numero-positivo> := <ditigo>* <digito>
;<numero-negativo> := - <digito>* <digito>
;<identificador> := (<letra> | <digito> | ?)*
;<flotante-positivo> := <digito>* <digito> . <digito>* <digito>
;<flotante-negativo> := - <digito>* <digito> . <digito>* <digito
;<booleano> := True | False
(define scanner-spec-simple-interpreter
'((white-sp
   (whitespace) skip)
  (comment
   ("!" (arbno (not #\newline))) skip)
  (identifier
   (letter (arbno (or letter digit "?"))) symbol)
  (number
   (digit (arbno digit)) number)
  (number
   ("-" digit (arbno digit)) number)
  (number ;;definición de los números decimales positivos
   ((arbno digit) digit "." digit (arbno digit) ) number) 
   (number ;;definición de los números decimales negativos
   ("-" (arbno digit) digit "." digit (arbno digit)) number)
  ))

;))Especificación Sintáctica (gramática)

(define grammar-simple-interpreter
  '((program (expression) a-program)
    (expression (number) lit-exp)
    (expression (identifier) var-exp)
    (expression
     ;(primitive "(" (separated-list expression ",")")")
     ; primapp-exp)
     ("evaluate" expression primitive expression )
         evaluate)
	(expression ("print" "(" expression  ")") 
	 			print-exp)
    ;(expression ("if" expression "then" expression "else" expression)
    ;            if-exp)
    (expression ("if" expression ":" expression (arbno expression) 
    	      (arbno "elif" expression ":" (arbno expression) "end")
    	      "else" ":" (arbno expression) "end") if-exp)
    (expression ("let" (arbno identifier "=" expression) "in" expression)
                let-exp)
    (expression ("proc" "(" (arbno identifier) ")" expression)
                proc-exp)
    (expression ( "(" expression (arbno expression) ")")
                app-exp)
    (expression ("letrec" (arbno identifier "(" (separated-list identifier ",") ")" "=" expression)  "in" expression) 
                letrec-exp)
    
    ; características adicionales
    (expression ("begin" expression (arbno ";" expression) "end")
                begin-exp)
    (expression ("set" identifier "=" expression)
                set-exp)
    (expression ("empty") list-empty-exp)
    (expression ("cons" "(" expression "," expression ")") cons-exp)
    ;;;;;;

    (primitive ("+") add-prim)
    (primitive ("-") substract-prim)
    (primitive ("*") mult-prim)
    (primitive ("/") div-prim)
    (primitive ("%") mod-prim)
    (primitive ("<") menor-prim)
    (primitive (">") mayor-prim)
    (primitive ("<=") menor-o-igual-prim)
    (primitive (">=") mayor-o-igual-prim)
    (primitive ("==") igualdad-prim)
    (primitive ("!=") diferente-prim)
    (primitive ("and") and-prim)
    (primitive ("or") or-prim)
    (primitive ("not") not-prim)
    (primitive ("add1") incr-prim)
    (primitive ("sub1") decr-prim)
    (boolean ("True") bool-true)
    (boolean ("False") bool-false)
	))


;Tipos de datos para la sintaxis abstracta de la gramática

;Construidos manualmente:

;(define-datatype program program?
;  (a-program
;   (exp expression?)))
;
;(define-datatype expression expression?
;  (lit-exp
;   (datum number?))
;  (var-exp
;   (id symbol?))
;  (primapp-exp
;   (prim primitive?)
;   (rands (list-of expression?)))
;  (if-exp
;   (test-exp expression?)
;   (true-exp expression?)
;   (false-exp expression?))
;  (let-exp
;   (ids (list-of symbol?))
;   (rans (list-of expression?))
;   (body expression?))
;  (proc-exp
;   (ids (list-of symbol?))
;   (body expression?))
;  (app-exp
;   (proc expression?)
;   (args (list-of expression?)))
;  (letrec-exp
;   (proc-names (list-of symbol?))
;   (idss (list-of (list-of symbol?)))
;   (bodies (list-of expression?))
;   (body-letrec expression?))
;  (begin-exp
;   (exp expression?)
;   (exps (list-of expression?)))
;  (set-exp
;   (id symbol?)
;   (rhs expression?)))
;
;(define-datatype primitive primitive?
;  (add-prim)
;  (substract-prim)
;  (mult-prim)
;  (incr-prim)
;  (decr-prim))

;Construidos automáticamente:

(sllgen:make-define-datatypes scanner-spec-simple-interpreter grammar-simple-interpreter)

(define show-the-datatypes
  (lambda () (sllgen:list-define-datatypes scanner-spec-simple-interpreter grammar-simple-interpreter)))

;*******************************************************************************************
;Parser, Scanner, Interfaz

;El FrontEnd (Análisis léxico (scanner) y sintáctico (parser) integrados)

(define scan&parse
  (sllgen:make-string-parser scanner-spec-simple-interpreter grammar-simple-interpreter))

;El Analizador Léxico (Scanner)

(define just-scan
  (sllgen:make-string-scanner scanner-spec-simple-interpreter grammar-simple-interpreter))

;El Interpretador (FrontEnd + Evaluación + señal para lectura )

(define interpretador
  (sllgen:make-rep-loop  "--> "
    (lambda (pgm) (eval-program  pgm)) 
    (sllgen:make-stream-parser 
      scanner-spec-simple-interpreter
      grammar-simple-interpreter)))

;*******************************************************************************************
;El Interprete

;eval-program: <programa> -> numero
; función que evalúa un programa teniendo en cuenta un ambiente dado (se inicializa dentro del programa)

(define eval-program
  (lambda (pgm)
    (cases program pgm
      (a-program (body)
                 (eval-expression body (init-env))))))

; Ambiente inicial
;(define init-env
;  (lambda ()
;    (extend-env
;     '(x y z)
;     '(4 2 5)
;     (empty-env))))

(define init-env
  (lambda ()
    (extend-env
     '(i v x)
     '(1 5 10)
     (empty-env))))

;(define init-env
;  (lambda ()
;    (extend-env
;     '(x y z f)
;     (list 4 2 5 (closure '(y) (primapp-exp (mult-prim) (cons (var-exp 'y) (cons (primapp-exp (decr-prim) (cons (var-exp 'y) ())) ())))
;                      (empty-env)))
;     (empty-env))))

;eval-expression: <expression> <enviroment> -> numero
; evalua la expresión en el ambiente de entrada
(define eval-expression
  (lambda (exp env)
    (cases expression exp
      (lit-exp (datum) datum)
      (var-exp (id) (apply-env env id))
      (evaluate (exp-1 prim exp-2)
                   (evaluar-evaluate (evaluate exp-1 prim exp-2) env))
      (if-exp (test-expression true-expression-first true-expressions-rest elif-test-expression elif-expressions false-expressions)
              (if (true-value? (eval-expression test-expression env))
                  (eval-expression true-expression-first env)
                  (eval-expression true-expression-first env)))
	  (print-exp (exp)
	   			 (display (eval-expression exp env)))
      (let-exp (ids rands body)
               (let ((args (eval-rands rands env)))
                 (eval-expression body
                                  (extend-env ids args env))))
      (proc-exp (ids body)
                (closure ids body env))
      (app-exp (rator rands)
               (let ((proc (eval-expression rator env))
                     (args (eval-rands rands env)))
                 (if (procval? proc)
                     (apply-procedure proc args)
                     (eopl:error 'eval-expression
                                 "Attempt to apply non-procedure ~s" proc))))
      (letrec-exp (proc-names idss bodies letrec-body)
                  (eval-expression letrec-body
                                   (extend-env-recursively proc-names idss bodies env)))
      (set-exp (id rhs-exp)
               (begin
                 (setref!
                  (apply-env-ref env id)
                  (eval-expression rhs-exp env))
                 1))
      (begin-exp (exp exps) 
                 (let loop ((acc (eval-expression exp env))
                             (exps exps))
                    (if (null? exps) 
                        acc
                        (loop (eval-expression (car exps) 
                                               env)
                              (cdr exps)))))
      (list-empty-exp() empty)
      (cons-exp (exp lis) (cons exp lis))
      )))

; funciones auxiliares para aplicar eval-expression a cada elemento de una 
; lista de operandos (expresiones)
(define eval-rands
  (lambda (rands env)
    (map (lambda (x) (eval-rand x env)) rands)))
; reordena una estructura evaluate de acuerdo a la precedencia
; evaluate-struct -> evaluate-struct-precedence-order

(define ordenar-evaluate (lambda (exp)
                           (cases program exp
                             (a-program (exp)
                                        (cases expression exp
                                          (evaluate (exp1 prim exp2) "hola mudo")
                                          (else " no es un evaluate")))
                             (else "que mira prro >:v")
                             )
                           )
  )

; extraer evaluates con modulos de un e
(define eval-rand
  (lambda (rand env)
    (eval-expression rand env)))

;apply-primitive: <primitiva> <list-of-expression> -> numero
(define apply-primitive
  (lambda (prim args)
    (cases primitive prim
      (add-prim () (+ (car args) (cadr args)))
      (substract-prim () (- (car args) (cadr args)))
      (mod-prim () (modulo (car args) (cadr args)))
      (mult-prim () (* (car args) (cadr args)))
      (div-prim () (/ (car args) (cadr args)))
      (incr-prim () (+ (car args) 1))
      (decr-prim () (- (car args) 1))
      (menor-prim () (if (< (car args) (cadr args)) (bool-true) (bool-false)))
      (mayor-prim () (if (> (car args) (cadr args)) (bool-true) (bool-false)))
      (menor-o-igual-prim () (if (<= (car args) (cadr args)) (bool-true) (bool-false)))
      (mayor-o-igual-prim () (if (>= (car args) (cadr args)) (bool-true) (bool-false)))
      (igualdad-prim () (if (eq? (car args) (cadr args)) (bool-true) (bool-false)))
      (diferente-prim () (if (not (eq? (car args) (cadr args))) (bool-true) (bool-false)))
      (and-prim () (if (< (car args) (cadr args)) (bool-true) (bool-false)))
      (or-prim () (if (< (car args) (cadr args)) (bool-true) (bool-false)))
      (not-prim () (if (< (car args) (cadr args)) (bool-true) (bool-false)))
      )))

;true-value?: determina si un valor dado corresponde a un valor booleano falso o verdadero
(define true-value?
  (lambda (x)
    (not (zero? x))))

;*******************************************************************************************
;Procedimientos
(define-datatype procval procval?
  (closure
   (ids (list-of symbol?))
   (body expression?)
   (env environment?)))

;apply-procedure: evalua el cuerpo de un procedimientos en el ambiente extendido correspondiente
(define apply-procedure
  (lambda (proc args)
    (cases procval proc
      (closure (ids body env)
               (eval-expression body (extend-env ids args env))))))

;*******************************************************************************************
;Ambientes

;definición del tipo de dato ambiente
(define-datatype environment environment?
  (empty-env-record)
  (extended-env-record
   (syms (list-of symbol?))
   (vec vector?)
   (env environment?)))

(define scheme-value? (lambda (v) #t))

;empty-env:      -> enviroment
;función que crea un ambiente vacío
(define empty-env  
  (lambda ()
    (empty-env-record)))       ;llamado al constructor de ambiente vacío 


;extend-env: <list-of symbols> <list-of numbers> enviroment -> enviroment
;función que crea un ambiente extendido
(define extend-env
  (lambda (syms vals env)
    (extended-env-record syms (list->vector vals) env)))

;extend-env-recursively: <list-of symbols> <list-of <list-of symbols>> <list-of expressions> environment -> environment
;función que crea un ambiente extendido para procedimientos recursivos
(define extend-env-recursively
  (lambda (proc-names idss bodies old-env)
    (let ((len (length proc-names)))
      (let ((vec (make-vector len)))
        (let ((env (extended-env-record proc-names vec old-env)))
          (for-each
            (lambda (pos ids body)
              (vector-set! vec pos (closure ids body env)))
            (iota len) idss bodies)
          env)))))

;iota: number -> list
;función que retorna una lista de los números desde 0 hasta end
(define iota
  (lambda (end)
    (let loop ((next 0))
      (if (>= next end) '()
        (cons next (loop (+ 1 next)))))))

;(define iota
;  (lambda (end)
;    (iota-aux 0 end)))
;
;(define iota-aux
;  (lambda (ini fin)
;    (if (>= ini fin)
;        ()
;        (cons ini (iota-aux (+ 1 ini) fin)))))
;(bool-true) (bool-false)))
;función que busca un símbolo en un ambiente
(define apply-env
  (lambda (env sym)
    (deref (apply-env-ref env sym))))

(define apply-env-ref
  (lambda (env sym)
    (cases environment env
      (empty-env-record ()
                        (eopl:error 'apply-env-ref "No binding for ~s" sym))
      (extended-env-record (syms vals env)
                           (let ((pos (rib-find-position sym syms)))
                             (if (number? pos)
                                 (a-ref pos vals)
                                 (apply-env-ref env sym)))))))


;*******************************************************************************************
;Referencias

(define-datatype reference reference?
  (a-ref (position integer?)
         (vec vector?)))

(define deref
  (lambda (ref)
    (primitive-deref ref)))

(define primitive-deref
  (lambda (ref)
    (cases reference ref
      (a-ref (pos vec)
             (vector-ref vec pos)))))

(define setref!
  (lambda (ref val)
    (primitive-setref! ref val)))

(define primitive-setref!
  (lambda (ref val)
    (cases reference ref
      (a-ref (pos vec)
             (vector-set! vec pos val)))))


;****************************************************************************************
;Funciones Auxiliares

; funciones auxiliares para encontrar la posición de un símbolo
; en la lista de símbolos de un ambiente

(define rib-find-position 
  (lambda (sym los)
    (list-find-position sym los)))

(define list-find-position
  (lambda (sym los)
    (list-index (lambda (sym1) (eqv? sym1 sym)) los)))

(define list-index
  (lambda (pred ls)
    (cond
      ((null? ls) #f)
      ((pred (car ls)) 0)
      (else (let ((list-index-r (list-index pred (cdr ls))))
              (if (number? list-index-r)
                (+ list-index-r 1)
                #f))))))


;Funcion que convierte una s-list de cualquier tipo y profundidad en una lista
;slist->list

(define extraer-valores-slist (lambda (s-list)
                      (cond
                      ((null? s-list) '())  
                      ((list? (car s-list)) (append (extraer-valores-slist (car s-list)) (extraer-valores-slist (cdr s-list))))
                      (else (cons (car s-list) (extraer-valores-slist (cdr s-list))))
                      )
                        )
  )
;Funcion que convierte un programa en una lista de estructuras (solo si el programa es evaluate) haciendo las veces de unparser
;program->slist 
(define unparse-program
		(lambda (prog)
		 (cases program prog
		  (a-program (exp)   (unparse-evaluate exp))
		  )
		 )
		)
;Funcion que convierte una estructura evaluate en una s-list de programas y primitivas sin importar su profundidad
;evaluate-exp->slist-expressions
(define unparse-evaluate
		(lambda (exp)
		   (cases expression exp
			(evaluate (exp1 prim exp2)
			 (list (unparse-evaluate exp1)  prim (unparse-evaluate exp2)))
		   (else  exp)
		   )
		  )
		 )
;evaluate-exp->list
;(define unparse-evaluate-to-list
;		(lambda (prog)
;	 (extraer-valores-slist (unparse-program prog))))
(define unparse-evaluate-to-list
		(lambda (prog)
		 (extraer-valores-slist (unparse-evaluate prog))))
;Funcion que evalua la primera operacion existente en una lista de expresiones y operaciones
;ejemplo: (evaluar-prim (list prog-a + 5 * 8 - 9)) = (eval-prog prog-a) + 5 = 9 suponiendo que a evaluado de como resultado 4
;lista-operaciones->lit-exp
(define evaluar-prim
		(lambda (lista-expresiones env)
		 (lit-exp (apply-primitive  (cadr lista-expresiones) (list (eval-expression(car lista-expresiones) env) (eval-expression(caddr lista-expresiones) env))
		))
		)
  )
;Funcion que evalua todas las operaciones de modulo existentes en una lista de programas y expresiones y retorna la lista resultante
;ejemplo: (evaluar-mod (list prog-a + 5 % 3 - 9)) = (list prog-a + 2 - 9)
;lista-operaciones->lista-operaciones
(define evaluar-mod
		(lambda (lista-expresiones env)
		 (if (< (length lista-expresiones) 2)  lista-expresiones
		 (cases primitive (cadr lista-expresiones)
		  (mod-prim ()  (evaluar-mod (cons (evaluar-prim lista-expresiones env) (cdddr lista-expresiones)) env))
		  (else (append  (list (car lista-expresiones)) (list (cadr lista-expresiones))  (evaluar-mod (cddr lista-expresiones) env )))
		 )
		 )
		)
		)
;Funcion que evalua todas las operaciones de division y multiplicacion  existentes en una lista de expreciones y operaciones y retorna la lista resultante
;ejemplo: (evaluar-division-multiplicacion (list prog-a + 4 * 8 + 5 - 9 / 9)) = (list prog-a + 48 + 5 - 1)
;lista-operaciones->lista-operaciones
(define evaluar-division-multiplicacion
		(lambda (lista-expresiones env)
		 (if (< (length lista-expresiones) 2)  lista-expresiones
		 (cases primitive (cadr lista-expresiones)
		  (mult-prim ()  (evaluar-division-multiplicacion (cons (evaluar-prim lista-expresiones env) (cdddr lista-expresiones)) env))
                  (div-prim ()  (evaluar-division-multiplicacion (cons (evaluar-prim lista-expresiones env) (cdddr lista-expresiones)) env))
		  (else (append  (list (car lista-expresiones)) (list (cadr lista-expresiones))  (evaluar-division-multiplicacion (cddr lista-expresiones) env )))
		 )
		 )
		)
		)
;Funcion que evalua todas las operaciones de suma  y resta  existentes en una lista de expreciones y operaciones y retorna la lista resultante
;ejemplo: (evaluar-suma-resta (list prog-a + 4 + 8 - 1)) = (list prog-a + 11)
;lista-operaciones->lista-operaciones

(define evaluar-suma-resta
		(lambda (lista-expresiones env)
		 (if (< (length lista-expresiones) 2)  lista-expresiones
		 (cases primitive (cadr lista-expresiones)
		  (add-prim ()  (evaluar-suma-resta (cons (evaluar-prim lista-expresiones env) (cdddr lista-expresiones)) env))
                  (substract-prim ()  (evaluar-suma-resta (cons (evaluar-prim lista-expresiones env) (cdddr lista-expresiones)) env))
		  (else (append  (list (car lista-expresiones)) (list (cadr lista-expresiones))  (evaluar-suma-resta (cddr lista-expresiones) env )))
		 )
		 )
		)
		)
;; Funcion que devuelve un valor numerico (0, 1 o 2) dependiendo de si la lista de operaciones primitivas contiene operaciones matematicas (1) o logicas (2) o una combinacion de estas
;; caso en el cual el evaluate es incorrecto  y retorna 0
;; lista-operaciones-primitivas -> integer
;; el valor por defecto es -1
(define tipo-lista-operaciones
		(lambda (lista-op num-operaciones-matematicas num-operaciones-logicas)
		 (if (< (length lista-op ) 2)
		  (cond	 ((and (= num-operaciones-logicas 0) (> num-operaciones-matematicas 0)) 1)
		  		 ((and (> num-operaciones-logicas 0) (= num-operaciones-matematicas 0)) 2)
				 ((and (> num-operaciones-matematicas 0) (> num-operaciones-logicas 0)) 0)
				 )
		  (cases primitive (cadr lista-op)
		   (add-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (substract-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (mult-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (div-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (mod-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (incr-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (decr-prim () (tipo-lista-operaciones (cddr lista-op) (+ num-operaciones-matematicas 1) num-operaciones-logicas))
		   (menor-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (mayor-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (menor-o-igual-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (mayor-o-igual-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
                    (igualdad-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (diferente-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (and-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (or-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		   (not-prim () (tipo-lista-operaciones (cddr lista-op) num-operaciones-matematicas (+ num-operaciones-logicas 1)))
		 )
)
)
)
; Funcion que recive una expresion evaluate y retorna el valor resultante ademas de intentar validar su sintaxis, no se manejan todas las excepciones
; aunque se intento, por ejemplo si se digita evaluate 3 + evaluate 1 < 2 se encuentra un error no controlado, pero se asegura que 
; todas las expresiones que tengan logica sintactica se evaluaran y se retornara su respectivo resultado, ademas de garantizar
; que la precedencia de operadores en el siguiente orden de mayor a menor: (% * / + -)
(define evaluar-evaluate
  (lambda (eval-exp env)
 (cond ((= (tipo-lista-operaciones (unparse-evaluate-to-list eval-exp) 0 0) 1)
    (cases expression (car (evaluar-suma-resta (evaluar-division-multiplicacion (evaluar-mod (unparse-evaluate-to-list eval-exp) env) env) env))
      (lit-exp (numero) numero)
      (else eopl:error "algo anda mal muy mal")
  ))
((= (tipo-lista-operaciones(unparse-evaluate-to-list eval-exp) 0 0) 2)
	 (cases expression eval-exp 
	  (evaluate (exp1 prim exp2) 
	   (apply-primitive prim (list (eval-expression exp1 env) (eval-expression exp2 env))))
	   (else eopl:error "algo anda mal muy mal")
  )
	 )
(else 	 (cases expression eval-exp 
	  (evaluate (exp1 prim exp2) 
	   (apply-primitive prim (list (eval-expression exp1 env) (eval-expression exp2 env))))
	   (else eopl:error "algo anda mal muy mal")
  )

    )
 )
)
) 
  
  

;(evaluar-mod(unparse-evaluate-to-list (scan&parse "evaluate 4 % evaluate 5 + evaluate 2 - 1")) init-env)
; (display  (unparse-evaluate-to-list (scan&parse"evaluate evaluate 6 - 1 % evaluate 5 + evaluate 2 - evaluate 5 * 3")) )
; (newline)
; (newline)
; (display (evaluar-mod (unparse-evaluate-to-list (scan&parse "evaluate evaluate 6 - 1 % evaluate 5 + evaluate 2 - evaluate 5 * 3")) init-env))
; (newline)
; (newline)
; (display (evaluar-division-multiplicacion (evaluar-mod (unparse-evaluate-to-list (scan&parse "evaluate evaluate 6 - 1 % evaluate 5 + evaluate 2 - evaluate 5 * 3")) init-env) init-env))
; (newline)
; (newline)
; (display (evaluar-suma-resta  (evaluar-division-multiplicacion (evaluar-mod (unparse-evaluate-to-list (scan&parse "evaluate evaluate if 1 then 4 else 4 - 1 % evaluate 5 + evaluate 2 - evaluate 5 * 3")) init-env) init-env)init-env))
; 

(interpretador)
