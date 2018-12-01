// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import { Algoritmos } from './application'

function Lista(props) {

  const lista = props.registros.map((registro, id) => (
    <tr key={id}>
      <td className="font">{registro.id}</td>
      <td className="font">{registro.cipher}</td>
      <td className="font">{Algoritmos.find(e => e.id === registro.tipo).nombre}</td>
      <td>
        <button onClick={_ => props.onBtnUsar(registro)} className="btn btn-primary btn-cripto">Usar</button>
      </td>
    </tr>
  ))

  return (
    <table className="table">
      <thead id="cabeza_t">
        <tr>
          <th className="font">id</th>
          <th className="font">Ciphertext</th>
          <th className="font">Algoritmo</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        {lista}
      </tbody>
    </table>
  )
}

class Root extends React.Component {

  state = {
    input: "",
    output: "",
    key: "",
    alg: Algoritmos[1].id,
    registros: [],
  }

  constructor(props) {
    super(props)

    this.listenerInput = this.listenerInput.bind(this)
    this.listenerOutput = this.listenerOutput.bind(this)
    this.listenerKey = this.listenerKey.bind(this)
    this.listenerConsultar = this.listenerConsultar.bind(this)
    this.listenerClear = this.listenerClear.bind(this)
    this.listenerChangeAlgorithm = this.listenerChangeAlgorithm.bind(this)
    this.respuestaServidor = this.respuestaServidor.bind(this)
  }

  listenerInput(e) {
    this.setState({ input: e.target.value })
  }

  listenerOutput(e) {
    this.setState({ output: e.target.value })
  }

  listenerKey(e) {
    this.setState({ key: e.target.value })
  }

  listenerClear() {
    this.setState({ input: "", output: "" })
  }

  listenerChangeAlgorithm(e) {
    if (e.target.value === "rsa")
      window.location.assign("firma")
    this.setState({ alg: e.target.value })
  }

  listenerBtnUsar(obj) {
    this.setState({ output: obj.cipher, alg: obj.tipo })
  }

  respuestaServidor(data) {
    const registros = this.state.registros.concat({
      id: data.id,
      cipher: data.output,
      tipo: this.state.alg,
    })
    this.setState({ ...data, registros })
  }

  listenerConsultar(e) {

    if (this.state.key.trim() == "") {
      alert("Debe tener la llave")
      return;
    }

    if (this.state.input.trim() == "" && this.state.output.trim() == "") {
      alert("debe tener texto plain-text o cipher-text")
      return;
    }

    if (this.state.input.trim() != "") {

      const payload = { input: this.state.input, key: this.state.key }

      fetch(`${this.state.alg}/cifrar`, {
        method: "post",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      })
        .then(resp => resp.json())
        .then(this.respuestaServidor)

      return;
    }

    if (this.state.output.trim() != "") {
      const payload = { output: this.state.output, key: this.state.key }
      fetch(`${this.state.alg}/descifrar`, {
        method: "post",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      })
        .then(resp => resp.json())
        .then(data => this.setState(data))
      return;
    }

  }

  componentDidMount() {
    fetch("cipher_text", {
      method: "get",
      headers: { "Content-Type": "application/json" },
    }).then(resp => resp.json())
      .then(registros => this.setState({ registros }))
  }

  render() {

    const opcionesAlgorithmos = Algoritmos.map(alg => (
      <option value={alg.id} key={alg.id}>{alg.nombre}</option>
    ))


    return (
      <div>
        
        <button onClick={() => window.location.assign("registrarse")}>registrarse</button>
        <button onClick={() => window.location.assign("mensajes")}>Temporal</button>
        <div >
        <h1 className="titulo_form" align="center">Empecemos</h1>

        <div className="form ">
          <div className="row">
            <div className="col">
              <div className="form-group">
                <label className="titulo_form" htmlFor="input">Ingresa el texto que deseas encriptar:</label>
                <textarea name="input" onChange={this.listenerInput} value={this.state.input}
                  className="form-control" disabled={this.state.output.trim() !== ""} style={{resize: "none"}} />
              </div>
            </div>
            <div className="col">
              <div className="form- ">
                <label className="titulo_form" htmlFor="key">Ingresa la llave(mínimo 16 caracteres):</label>
                <textarea name="key" onChange={this.listenerKey} value={this.state.key}
                  className="form-control" style={{resize: "none"}} />
              </div>
            </div>
          </div>

          <div className="form-group">
            <label className="titulo_form" htmlFor="key">Este es el texto cifrado:</label>
            <textarea name="output" onChange={this.listenerOutput} value={this.state.output}
              className="form-control" disabled={this.state.input.trim() !== ""} style={{resize: "none"}} />
          </div>

          <div className="form-group">
            <label className="titulo_form" htmlFor="key">Elige el algoritmo que deseas utilizar:</label>
            <div className="form-group" id="desplegable">
              <select className="form-control" onChange={this.listenerChangeAlgorithm} value={this.state.alg}>
                {opcionesAlgorithmos}
              </select>
            </div>
          </div>

          <div className="text-center">
            <div className="btn-group my-4" >
              <button className="btn btn-primary btn-cripto" onClick={this.listenerConsultar}>
                Consultar
              </button>
              <button className="btn btn-primary btn-cripto" onClick={this.listenerClear}>
                Limpiar
              </button>
            </div>
          </div>

        </div>
        <Lista onBtnUsar={this.listenerBtnUsar.bind(this)} registros={this.state.registros} />
      </div>
      </div>
    )
  }
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Root />,
    document.getElementById("home-index")
    // document.body.appendChild(document.createElement('div')),
  )
})
