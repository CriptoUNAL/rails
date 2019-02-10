class HomeController < ApplicationController
  
  def index
  end

  def consultar_cipher
    render json: Input.all
  end

  def signature
    redirect_to registrarse_path unless session[:current_user_id]
  end



  def signup
  end

  def messages
  end

end
