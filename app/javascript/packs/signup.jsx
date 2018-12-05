// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'


class Root extends React.Component {

    state = {
        mensaje: "",
        id: false
    }
    constructor(props) {
        super(props)

        this.listenerSignUp = this.listenerSignUp.bind(this)
    }

    componentWillMount() {
    }

    listenerSignUp(e) {

        if (document.getElementById("inputUserame") != null && document.getElementById("inputPassword") != null) {
            const payload = { user: document.getElementById("inputUserame").value, pass: document.getElementById("inputPassword").value }

            //alert(document.getElementById("inputEmail").value);
            fetch(`register`, {
                method: "post",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            })
                .then(resp => resp.json())
                //.catch(_ => alert( "Error en el proceso" ))
                .then(data => console.log(data))
                .then(window.location.assign("chat"))

            setTimeout(alert("Al crear un usuario, se aceptan los terminos y condiciones"), 4000);
        }
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
        return (
            <div id = "registris" class ="container-fluid">
                <img id = "rola" src="https://image.flaticon.com/icons/png/512/1057/1057659.png" width="70" height="70" class="d-inline-block align-top" alt=""></img>
                 <h1 id = "refa">Ingreso</h1>
                <div class="container" id="flet">
                    <div className="row">
                        <div className="col-lg-4">
                            .
                </div>
                    <div id = "feto" className="col-lg-4">
                        <div className="card card-signin flex-row my-5">
                            <div className="card-body">
                                <form className="form-signin">
                                    <div className="form-label-group">
                                        <input type="text" id="inputUserame" className="form-control" placeholder="Username" required autoFocus></input>
                                        <label htmlFor="inputUserame">Usuario</label>
                                    </div>
                                                <div className="form-label-group">
                                                    <input type="password" id="inputPassword" className="form-control" placeholder="Password" required></input>
                                                    <label htmlFor="inputPassword">Contraseña</label>
                                                </div>
                                                <button id = "buton" className="btn btn-lg btn-primary btn-block text-uppercase" type="submit" onClick={this.listenerLogin} > Login </button>
                                                <button id = "buton2" className="btn btn-lg btn-primary btn-block text-uppercase" type="submit" onClick={this.listenerSignUp} > Sign Up</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            <div className="col-lg-4">
                                .   
                    </div>
                        </div>
                    </div>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <br></br>
                <div class = "container-fluid footer">
                        <p id = "footer"> © 2018 Copyright: Spectre Algorithm, all rights reserved </p>
                    </div>
                </div>
            ) 
    }
}

document.addEventListener('turbolinks:load', () => {
    console.log("carga completa ")
    ReactDOM.render(
        <Root />,
        document.getElementById("home-index")
    )
})
