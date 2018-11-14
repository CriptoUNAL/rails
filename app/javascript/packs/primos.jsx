export default class Primos {
  static primos = null
  lista = []
  limit = 0
  loaded = false

  static getInstance() {
    if (!Primos.primos)
      Primos.primos = new Primos()
    return Primos.primos
  }

  constructor() {
    this.generar = this.generar.bind(this)
    if (Primos.primos) throw new Error("Ya hay una estancia")
    fetch('/rsa/primos.json', {
      method: 'GET'
    })
      .then(resp => resp.json())
      .then(obj => {
        this.limit = obj.length
        this.lista = obj.data
      })
      .then( _ => this.loaded = true)
  }

  generar() {
    if(!this.loaded) return null
    return this.lista[Math.floor(Math.random() * this.limit)]
  }

}