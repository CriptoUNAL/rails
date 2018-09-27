class DesController < ApplicationController
  
  def cifrar
    input = params[:input]
    key = params[:key]
    
    ans = {
      output: "#{input} sera cifrado"
    }
    
    render json: ans
  end
  
  def descifrar
    output = params[:output]
    key = params[:key]

    ans = {
      input: "#{output} sera descifrado"
    }

    render json: ans
  end
end
