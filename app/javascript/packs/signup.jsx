// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'


class Root extends React.Component {


  render() {



    return (
      <div>
        <div className="row">
                <div className="col-lg-10 col-xl-9 mx-auto">
                    <div className="card card-signin flex-row my-5">
                        <div className="card-img-left d-none d-md-flex">
                        </div>
                        <div className="card-body">
                            <h5 className="card-title text-center">Regístrate</h5>
                            <form className="form-signin">
                                <div className="form-label-group">
                                    <input type="text" id="inputUserame" className="form-control" placeholder="Username" required autoFocus></input>
                                    <label htmlFor="inputUserame">Usuario</label>
                                </div>
                                <div className="form-label-group">
                                    <input type="email" id="inputEmail" className="form-control" placeholder="Email address" required></input>
                                    <label htmlFor="inputEmail">Email </label>
                                </div>
                                <div className="form-label-group">
                                    <input type="password" id="inputPassword" className="form-control" placeholder="Password" required></input>
                                    <label htmlFor="inputPassword">Contraseña</label>
                                </div>
                                <div className="form-label-group">
                                    <input type="password" id="inputConfirmPassword" className="form-control" placeholder="Password" required></input>
                                    <label htmlFor="inputConfirmPassword">Confirmar contraseña</label>
                                </div>
                                <button className="btn btn-lg btn-primary btn-block text-uppercase" type="submit" onClick={this.listenerSignUp} > >Registrarme</button>
                                <a  className="d-block text-center mt-2 small" href="/sign_in" target="_self">Iniciar sesión</a>
                            </form>
                        </div>
                    </div>
                </div>
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
