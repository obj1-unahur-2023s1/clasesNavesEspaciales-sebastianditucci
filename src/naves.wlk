class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var property combustible
	method cargarCombustible(cantidad) { combustible += cantidad }
	method acelerar(cuanto) { (velocidad +=  cuanto).min(100000)}
	method desacelerar(cuanto) { (velocidad -= cuanto).max(0) }
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	method acercarseUnPocoAlSol() { (direccion += 1).min(10) }
	method alejarseUnPocoDelSol() { (direccion -= 1).max(-10) }
	method prepararViaje() { 
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
    method estaTranquila() = combustible >= 4000 and velocidad <= 12000
    method estaDeRelajo() = self.estaTranquila()
}

class NaveBaliza inherits NaveEspacial {
	var property color
	var cambioDeColor = false
	method cambiarColorDeBaliza(colorNuevo) { 
		if (!cambioDeColor) { cambioDeColor = true }
		color = colorNuevo
	}
	override method prepararViaje() { 
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
		super()
	}
	override method estaTranquila() = super() and color != "rojo"
	method recibirAmenaza() {
		self.cambiarColorDeBaliza("rojo")
		self.irHaciaElSol()
	}
	override method estaDeRelajo() = super() and !cambioDeColor
} 

class NaveDePasajeros inherits NaveEspacial {
	var property cantidadPasajeros
	var racionesComida = 0
	var racionesBebida = 0
	var racionesDeComidaServidas = 0 
	method cargarComida(cantidad) { 
		racionesComida += cantidad
		racionesDeComidaServidas += cantidad
	}
	method descargarComida(cantidad) { (racionesComida -= cantidad).max(0) }
	method cargarBebida(cantidad) { racionesBebida += cantidad }
	method descargarBebida(cantidad) { (racionesBebida -= cantidad).max(0) }
	override method prepararViaje() {
		self.cargarComida(4 * cantidadPasajeros)
		self.cargarBebida(6 * cantidadPasajeros)
		self.acercarseUnPocoAlSol()
		super()
	}
	method recibirAmenaza() {
		self.descargarComida(cantidadPasajeros)
		self.descargarBebida(cantidadPasajeros * 2)
		velocidad = velocidad * 2
	}
	override method estaDeRelajo() = super() and racionesDeComidaServidas < 50
}

class NaveDeCombate inherits NaveEspacial {
	var property esInvisible
	var property misilesEstanDesplegados
	const mensajes = []
	method ponerseInvisible() { if (!esInvisible) { esInvisible = true } }
	method ponerseVisible() { if (esInvisible) { esInvisible = false } }
	method estaInvisible() = esInvisible
	method desplegarMisiles() { if (!misilesEstanDesplegados) { misilesEstanDesplegados = true } }
	method replegarMisiles() { if (misilesEstanDesplegados) { misilesEstanDesplegados = false } }
	method misilesDesplegados() = misilesEstanDesplegados
	method emitirMensaje(mensaje) { mensajes.add(mensaje) }
	method mensajesEmitidos() = mensajes
	method primerMensajeEmitido() = mensajes.first()
	method ultimoMensajeEmitido() = mensajes.last()
	method esEscueta() = mensajes.all({m => m.size() < 30})
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	override method prepararViaje() {
		self.ponerseVisible()
		self.desplegarMisiles()
		self.acelerar(1500)
		self.emitirMensaje("saliendo en mision")
		super()
	}
	override method estaTranquila() = super() and !misilesEstanDesplegados
	method recibirAmenaza() {
		self.emitirMensaje("Amenaza recibida")
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method estaDeRelajo() = super() and self.esEscueta()
}

class NaveHospital inherits NaveDePasajeros {
	var property quirofanosListos
	override method estaTranquila() = super() and !quirofanosListos
	override method recibirAmenaza() { 
		super()
		quirofanosListos = true
	}
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
	override method estaTranquila() = super() and !esInvisible
	override method recibirAmenaza() {
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}