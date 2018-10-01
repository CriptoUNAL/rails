// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'


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
      <div className="form ">
        <div className="form-group">
          <label htmlFor="input">Plain-text:</label>
          <textarea name="input" onChange={this.listenerInput} value={this.state.input}
            className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor="key">Key:</label>
          <textarea name="key" onChange={this.listenerKey} value={this.state.key}
            className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor="output">Cipher-text:</label>
          <textarea name="output" onChange={this.listenerOutput} value={this.state.output}
            className="form-control" />
        </div>

        <div className="form-group">
          <select className="form-control" onChange={this.listenerChangeAlgorithm} >
            {opcionesAlgorithmos}
          </select>
        </div>

        <button className="btn btn-primary" onClick={this.listenerConsultar}>
          Consultar
        </button>
        <button className="btn btn-primary" onClick={this.listenerClear}>
          Limpiar
        </button>

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
