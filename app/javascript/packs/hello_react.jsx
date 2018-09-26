// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'


class Root extends React.Component {
  state = {
    input: "",
    output: "",
  }

  constructor(props) {
    super(props)
    
    this.listenerInput = this.listenerInput.bind(this)
    this.listenerOutput = this.listenerOutput.bind(this)
    this.listenerConsultar = this.listenerConsultar.bind(this)
    this.listenerClear = this.listenerClear.bind(this)
  }

  listenerInput(e) {
    this.setState({ input: e.target.value })
  }

  listenerOutput(e) {
    this.setState({ output: e.target.value })
  }

  listenerConsultar(e){
    if(this.state.input.trim() == "" && this.state.output.trim() == ""){
      alert("Ingrese un input")
      return;
    }

    if(this.state.input.trim() != ""){
      this.setState({output: "la salida acá"})
      return;
    }
    
    if(this.state.output.trim() != ""){
      this.setState({input: "la entrada acá"})
      return;
    }

  }
  listenerClear(){
    this.setState({input: "", output: ""})
  }

  render() {
    return (
      <div>
        <label>
          Input:
        <textarea name="input" onChange={this.listenerInput} value={this.state.input} />
        </label>
        <label>
          Output:
        <textarea name="output" onChange={this.listenerOutput} value={this.state.output} />
        </label>
        <button onClick={this.listenerConsultar}>
          Consultar
        </button>
        <button onClick={this.listenerClear}>
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
