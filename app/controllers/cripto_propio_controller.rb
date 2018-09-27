class CriptoPropioController < ApplicationController
  def cifrar
    input = params[:input]
    key = params[:key]
    
    ans = {
      output: "#{input} cifrado inventado 🤙🏽"
    }
    
    render json: ans
  end
  
  def descifrar
    output = params[:output]
    key = params[:key]

    ans = {
      input: "#{output} decifrado inventado 🤙🏽"
    }

    render json: ans
  end

end
