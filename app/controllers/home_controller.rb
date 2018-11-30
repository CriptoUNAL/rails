class HomeController < ApplicationController
  
  def index
  end

  def consultar_cipher
    render json: Input.all
  end

  def signature
  end

  def signup
  end

end
