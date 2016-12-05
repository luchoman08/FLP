#Este archivo fue escrito en un .py solamente por que al abrirlo en un programa que 
#resalte sintaxis este se lee mas facilmente, no contiene codigo python ejecutable

#El interpretador fue escrito en la versión 6.7 de racket y solo soporta esta

#La siguiente es la especificacion de la expresión un for residente en el interpretador contenido en el archivo
#"interpretadorPython.rkt", con algunos ejemplos y descripción de los posibles limitantes
               
#Lo primero es que el for implementado en el interpretador python es una copia pobre del for in range de python, esta 
#copia se limita a solo la siguiente representación:

#Las variables definidas dentro del for no son visibles por fuera de este.

#Las variables definidas en un nivel de ejecución superior al for son visibles dentro de este,
#pero por la naturaleza de el ambiente no son modificables dentro

for var-name in range (val-start, val-end):
	expressions*
endfor

#Por ejemplo, el siguiente for escrito en python:
    for x in range(0,3):
        print "%d" % (x)               
        
#Se veria así en el presente interpretador:
	
for x in range (0,3):
	print(x)
endfor

#Vale decir que tanto el val-start como el val-end pueden ser expresiones, siempre y cuando estas 
#retornen un numero, de otra forma el interpretador dara resultados inesperados (no existe control de excepciones aún)

#Ejemplo 1:
def a():
	return 5
end
for x in range (evaluate 0 + 0, execute a()):
	var y = evaluate 50 + x 
	print(y)
	var z = y
	print(z)
endfor
	
#Ejemplo 2

for x in range (1,10):
	if evaluate x <= 5:
		print(x)
	else:
		print(evaluate x - 5)
	end
endfor
		
#La forma en que se implemento el for es muy aburrida de entender por lo que no entrare en detalle,
#pero he dejado una forma de conocer medianamente como funciona por si se quiere conocer, luego de ejecutar
#un for puede escribirse en el interpretador "fore" como si se estubiese llamando una variable
#o bien escribir en el interpretador "execute fore(0,5) y comparar esto con los resultados
#de la ejecuciòn del ultimo for"


