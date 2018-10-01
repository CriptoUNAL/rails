// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

class Brehynner extends React.Component {

  state = {
    registros:[]
  }

  componentDidMount(){
    fetch("cipher_text",{
    method: "get",
    headers: { "Content-Type": "application/json" },
    }).then(resp => resp.json())
    .then(registros => this.setState({registros}))
  }

  render(){     
    const lista = this.state.registros.map( (registro, id) => (
        <tr key={id}>
        <td id = "font">{registro.id}</td>
        <td id = "font">{registro.cipher}</td>
        <td id = "font">{registro.tipo}</td>
        <td>
          <button onClick={ _ => this.props.onBtnUsar(registro) } className="btn btn-primary">Usar</button>
        </td>
        </tr>
    ))

    return(
      <table className = "table">
        <thead id ="cabeza_t">
          <tr>
            <th id = "font" scope="col">id</th>
            <th id = "font" scope="col">Ciphertext</th>
            <th id = "font" scope="col">Algoritmo</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {lista}
        </tbody>
      </table>
    )
  }
}

class Root extends React.Component {

  algoritmos = ["inventado", "des"]

  state = {
    input: "",
    output: "",
    key: "",
    alg: this.algoritmos[0],
  }

  constructor(props) {
    super(props)

    this.listenerInput = this.listenerInput.bind(this)
    this.listenerOutput = this.listenerOutput.bind(this)
    this.listenerKey = this.listenerKey.bind(this)
    this.listenerConsultar = this.listenerConsultar.bind(this)
    this.listenerClear = this.listenerClear.bind(this)
    this.listenerChangeAlgorithm = this.listenerChangeAlgorithm.bind(this)
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
    this.setState({ alg: e.target.value })
  }

  listenerBtnUsar(obj){
    this.setState({ output: obj.cipher, alg:obj.tipo })
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
        .then(data => this.setState(data))

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

  render() {

    const opcionesAlgorithmos = this.algoritmos.map(alg => (
      <option value={alg} key={alg}>{alg}</option>
    ))


    return (
          <div className ="container" >
          <h1 id = "titulo_form" align ="center">Empecemos</h1>
          <div className="form ">
          <div className = "row">
            <div className = "col">
                <div className="form-group">
                  <label id = "titulo_form" htmlFor="input">Ingresa el texto que deseas encriptar:</label>
                  <textarea name="input" onChange={this.listenerInput} value={this.state.input}
                    className="form-control" />
                </div>       
            </div>
            <div className = "col">
              <div className="form- ">
                  <label id = "titulo_form" htmlFor="key">Ingresa la llave(mínimo 16 caracteres):</label>
                  <textarea name="key" onChange={this.listenerKey} value={this.state.key}
                    className="form-control" />
              </div>
            </div>
           </div>
            <div className = "row">
            <label id = "titulo_form" htmlFor="key">Elige el algoritmo que deseas utilizar:</label>
                <div className="form-group" id ="desplegable">
                    <select className="form-control" onChange={this.listenerChangeAlgorithm} >
                      {opcionesAlgorithmos}
                    </select>
                </div>
          </div>
              <div className="form-group">
              <label id = "titulo_form" htmlFor="key">Este es el texto cifrado:</label>
                <textarea name="output" onChange={this.listenerOutput} value={this.state.output}
                  className="form-control" />
              </div>
            <div id = "boton" >
              <button className="btn btn-primary" onClick={this.listenerConsultar}>
                Consultar
              </button>
              <button className="btn btn-primary" onClick={this.listenerClear}>
                Limpiar
              </button>
            </div>
            </div>
            <div>
              <h3 id="otro">asdasdas</h3>
            </div>
            <Brehynner onBtnUsar = {this.listenerBtnUsar.bind(this)}/>
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
