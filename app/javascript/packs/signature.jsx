// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'

function Contactos(props) {
  const contactos = props.contactos.map(contacto => {
    return (
      <li id = "lsts" key={contacto.id} className="list-group-item" onClick={_ => props.listenerClickContacto(contacto.name)} >
        <label className="contactos">
          {contacto.name}
        </label>
      </li>
    )
  })
  return (
    <ul className="list-group">
      {contactos}
    </ul>
  )
}

function Mensajes(props) {
  const mensajes = props.mensajes.map(msn => {
    return (
      <li key={msn.id} className="list-group" >
        <div className="row">
          <div className="col-5" />
          <div className="col-5 text-right">
            <p className="mens" contentEditable={true} onInput={e => props.listenerChangeMsn(e.target.innerText, msn.id)}
              onBlur={e => { props.listenerChangeMsn(e.target.innerText, msn.id) }}>
              {msn.message}
            </p>
          </div>
          <div className="col-2 text-right">
            <button className="btn-ver" onClick={_ => props.listenerVerificarFirma(msn)}>firma</button>
          </div>
        </div>


      </li>
    )
  })
  return (
    <ul className="list-group">
      {mensajes}
    </ul>
  )
}

function ChatText(props) {

  return (
    <div id = "relle" class = "container-fluid">
      <form className="inputForm">
        <input className="inputMen" type="text" name="mensaje" id="mensaje" value={props.mensaje} onChange={props.listenerCambioMensaje} />
        <button id = "flef" type="button" onClick={props.listenerEnviar} >Enviar</button>
      </form>

    </div>
  )
}


class Root extends React.Component {

  state = {
    currentContact: null,
    contactos: [],
    mensajes: [],
    mensaje: ""
  }

  constructor(props) {
    super(props)

    this.mensajeEnviadoCorrectamente = this.mensajeEnviadoCorrectamente.bind(this)
    this.listenerClickContacto = this.listenerClickContacto.bind(this)
    this.listenerCambioMensaje = this.listenerCambioMensaje.bind(this)
    this.listenerChangeMsn = this.listenerChangeMsn.bind(this)
    this.listenerEnviar = this.listenerEnviar.bind(this)
  }

  componentDidMount() {
    fetch('all_users')
      .then(data => data.json())
      .then(contactos => this.setState({ contactos }))
  }

  mensajeEnviadoCorrectamente(data) {
    this.setState({
      mensajes: this.state.mensajes.concat(data),
      mensaje: "",
    })
  }

  listenerVerificarFirma(msgObj) {
    const payload = {
      mensaje: msgObj.message
    }
    fetch(`comprobar/${msgObj.id}`, {
      method: "post",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
      .then(data => data.json())
      .then(data => {
        let ans = null;
        if (data.respuesta === true) {
          ans = "El mensaje corresponde al enviado por el remitente."
        } else {
          ans = "El mensaje esta corrupto."
        }

        alert(ans);
      })
  }

  listenerChangeMsn(message, id) {
    console.log("cambiendo e mensaje ,", id)
    const mensajes = this.state.mensajes.map(mensaje => {
      return mensaje.id === id
        ? { ...mensaje, message }
        : mensaje;
    })
    this.setState({ mensajes })
  }

  listenerClickContacto(user) {
    if (user === this.state.currentContact) return
    fetch(`chats/${user}`)
      .then(data => data.json())
      .then(mensajes => this.setState({ mensajes, currentContact: user }))

  }

  listenerEnviar() {
    if (!this.state.currentContact) {
      alert("selecciona primero un destinatario")
      return;
    }
    const payload = {
      destinatario: this.state.currentContact,
      mensaje: this.state.mensaje
    }
    fetch('create', {
      method: "post",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
      .then(data => data.json())
      .then(this.mensajeEnviadoCorrectamente)
  }

  listenerCambioMensaje(e) {
    this.setState({ mensaje: e.target.value })
  }

  render() {

    return (
      <div>
        <img id = "long" src="https://image.flaticon.com/icons/svg/868/868128.svg" width="50" height="50" class="d-inline-block align-top" alt=""></img>
        <h3 id = "relax"> Spectre Chat</h3>
        <br></br>
        <br></br>
        <br></br>
        <br></br>
        <a id = "ingresoz" href="/salir">Salir</a>
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
      <div className="bodyChat">
        <div id ="userrow" className="row" >
            <div className="col-4 padding r">
             <div className = "izqu" >
             <span class="dot"></span>
             <img id = "longe" src="https://image.flaticon.com/icons/svg/747/747545.svg" width="30" height="30" class="d-inline-block align-top" alt=""></img>
             </div>
            </div>
            <div className="col-8 padding-l">
            <div className="name">
                  <div class = "row">
                  <div id = "lele" classs = "col-6">
                  <br></br>
                  </div>
                  <div class = "col-6">
                  <div class = "username">
                    <p>{this.state.currentContact}</p>
                  </div>
                  </div>  
                  </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="cont col-4 padding-r">
            <Contactos contactos={this.state.contactos} listenerClickContacto={this.listenerClickContacto} />
          </div>
          <div className="col-8 padding-l">

            <div className="buzon container-fluid ">

              <Mensajes mensajes={this.state.mensajes} listenerChangeMsn={this.listenerChangeMsn}
                listenerVerificarFirma={this.listenerVerificarFirma} />
            </div>
           
          </div>
        </div>

         <div className="row">
          <div className="cont col-4 padding-r">
          <div id = "rellen" class = "container-fluid">
              <form className="inputForm">
              </form>
              </div>
          </div>
          <div className="col-8 padding-l">

           <div className="row">
              <ChatText listenerEnviar={this.listenerEnviar} mensaje={this.state.mensaje} listenerCambioMensaje={this.listenerCambioMensaje} />
          </div>
           
          </div>
        </div>
      </div>
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
  )
})
