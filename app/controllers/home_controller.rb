class HomeController < ApplicationController
  
  def index
  end

  def consultar_cipher
    render json: Input.all
  end

  def signature
    redirect_to registrarse_path unless session[:current_user_id]
  end

  def salir
    session.delete(:current_user_id)
    redirect_to registrarse_path
  end

  def signup
  end

end
