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



    render() {



        return (
            <div>
                <div className="container" id="flo">
                    <div className="row">
                        <div className="col-lg-2">
                            .
                         </div>
                        <div id="feto" className="col-lg-8">
                            <div className="card card-signin flex-row my-5">
                                <div className="card-body">
                                    <h2 className="card-title text-center"><strong>Regístrate</strong></h2>
                                    <div className="form form-signin">
                                        <div className="form-label-group" >
                                            <input type="text" id="inputUserame" className="form-control" placeholder="Username" required autoFocus></input>
                                            <label htmlFor="inputUserame">Usuario</label>
                                        </div>
                                        <div className="form-label-group">
                                            <input type="password" id="inputPassword" className="form-control" placeholder="Password" required></input>
                                            <label htmlFor="inputPassword">Contraseña</label>
                                        </div>
                                        <button className="btn btn-lg btn-primary btn-block text-uppercase" type="submit" onClick={this.listenerSignUp} > Sign Up</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="col-lg-2">
                            .
                        </div>
                    </div>
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
