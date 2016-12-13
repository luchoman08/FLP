#pruebas proyecto final

class Animal (null):
	field a
	field b
	def init():
		var a = 3
		var b = 6
	end
	def metodo (p, k):
		var a = evaluate a - p
		var b = evaluate b - k
		evaluate a + b
	end
	def getA() :
		a
	end
end
class Mamifero (Animal) :
	field c
	field d
	def init(k , y) :
		#super init()
		var c = evaluate y + a
		var d = evaluate k + b
		var c = 1
		var d = 1
	end
	def getC() :
		c
	end
end


#creacion de objetos
var nw = new Animal()
#var nv = new Mamifero()
