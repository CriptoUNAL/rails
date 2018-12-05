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
        <button id = "usar" onClick={_ => props.onBtnUsar(registro)} className="btn btn-primary btn-cripto">Usar</button>
      </td>
    </tr>
  ))

  return (
    <table className="table" bgcolor = "fffff">
      <thead id="cabeza_t">
        <tr>
          <th className="font">id</th>
          <th className="font">Ciphertext</th>
          <th className="font">Algoritmo utilizado</th>
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


  listenerLogin() {
    if (document.getElementById("inputUserame") != null && document.getElementById("inputPassword") != null) {
      const payload = { user: document.getElementById("inputUserame").value, pass: document.getElementById("inputPassword").value }

      //alert(document.getElementById("inputEmail").value);
      fetch(`log`, {
        method: "post",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      })
        .then(resp => resp.json())
        //.catch(_ => alert( "Error en el proceso" ))
        .then(data => {
          alert(data.mensaje)
          window.location.assign("chat")
        })
    }
  }

  render() {

    const opcionesAlgorithmos = Algoritmos.map(alg => (
      <option value={alg.id} key={alg.id}>{alg.nombre}</option>
    ))


    return (

      <div>
        <img id = "log" src="https://image.flaticon.com/icons/png/512/1057/1057659.png" width="70" height="70" class="d-inline-block align-top" alt=""></img>
        <h1 id = "rela">Spectre</h1>
        <button id = "ingreso" onClick={() => window.location.assign("registrarse")}>Ingreso</button>
          <br></br>
          <br></br>
          <br></br>
          <br></br>
          <br></br>
          <br></br>
          <br></br> 
          <div class = "row">
            <div class = "col-lg-6">
                <div id = "sty" class = "container">
                  <br></br>
                </div>
            </div>
            <div class = "col-lg-6">
                <div id = "le" class = "container">
                <br></br>
                </div>
            </div>
          </div>
          <br></br>
             <img id = "texta" src="https://image.flaticon.com/icons/svg/1000/1000929.svg" width="35" height="35" class="img-rounded" alt=""></img>
             <img id = "keya" src="https://image.flaticon.com/icons/svg/1000/1000943.svg" width="35" height="35" class="d-inline-block align-top" alt=""></img>
             <img id = "alga" src="https://image.flaticon.com/icons/svg/1000/1000921.svg" width="35" height="35" class="d-inline-block align-top" alt=""></img>
          <br></br>
          <br></br>
      <div class="row">
        <div id = "first" class = "col-lg-3" >
            <div className="form-group">
                    <label className="titulo_form" htmlFor="input">Ingresa el texto que deseas encriptar:</label>
                    <textarea name="input" onChange={this.listenerInput} value={this.state.input}
                      className="form-control" disabled={this.state.output.trim() !== ""} style={{resize: "none"}} />
            </div>
          </div>
     
          <div id = "second" class = "col-lg-3" >
             <div className="form- ">
                <label className="titulo_form" htmlFor="key">Ingresa la llave(mínimo 16 caracteres):</label>
                <textarea name="key" onChange={this.listenerKey} value={this.state.key}
                  className="form-control" style={{resize: "none"}} />
              </div>
          </div>
 
          <div id = "third" class = "col-lg-3" >
            <div className="form-group">
              <label className="titulo_form" htmlFor="key">Elige el algoritmo que deseas utilizar:</label>
              <div className="form-group" id="desplegable">
                <select className="form-control" onChange={this.listenerChangeAlgorithm} value={this.state.alg}>
                  {opcionesAlgorithmos}
                </select>
              </div>
            </div>
            <button id = "freela" className="btn btn-primary" onClick={this.listenerConsultar}>
                Consultar
            </button>
          </div>
        </div>
        <br></br>
        <br></br>
        <div class = "row">
        <div  class = "col-lg-3">

        </div>
        <div id = "fourth" class = "col-lg-6">
        
        <div className="form-group">
              <label className="titulo_form" htmlFor="key">Este es el texto cifrado:</label>
              <textarea name="output" onChange={this.listenerOutput} value={this.state.output}
                className="form-control" disabled={this.state.input.trim() !== ""} style={{resize: "none"}} />
            <br></br>
            </div>
              
              <button id = "ncer" className="btn btn-primary" onClick={this.listenerClear}>
                Limpiar
              </button>
        </div>
        <div  class = "col-lg-3">
        </div>

        </div>
        <br></br>
        <br></br>
        <Lista onBtnUsar={this.listenerBtnUsar.bind(this)} registros={this.state.registros} />
        <br></br>
        <br></br>
        <div class = "container-fluid footer">
            <p id = "footer"> © 2018 Copyright: Spectre Algorithm, all rights reserved </p>
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
