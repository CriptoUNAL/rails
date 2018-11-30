class MessagesController < ApplicationController

  def create
    destinatario = User.find_by(name:params[:destinatario])
    user = User.find_by(id: session[:current_user_id])

    firma = firmar(user.private_key.to_s,params[:mensaje])
    mensaje = Message.create(message: params[:mensaje],remitente: user.id, destinatario: destinatario.id, firma:firma)

    render json: [mensaje.firma,mensaje.id]#,ver_firma(user.public_key,firmar(user.private_key,""),mensaje)]
  end

  def comprobar_firma
    mensaje = Message.find(params[:id])
    user = User.find(mensaje.remitente)
    render json: [ver_firma(user.public_key,mensaje.firma,mensaje.message)]
  end

  def chats
    #recibe el emisor y al receptor para buscar los mensajes que se han enviado entre ellos
    other_user = User.find_by(name:params[:otra_persona])
    msgs = Message.all.where('remitente = ? AND destinatario = ?', session[:current_user_id], other_user.id)
    msgs += Message.all.where('remitente = ? AND destinatario = ?', other_user.id ,session[:current_user_id])
    msgs = msgs.sort
    render json: msgs
    #render json: [Message.select(:message,:id).find_by(remitente:session[:current_user_id]),Message.select(:message,:id).find_by(destinatario:session[:current_user_id])]
  end

  def edit
    mensaje = Message.find(params[:id])
    render json: mensaje
  end

  def update

  end

  private
  def firmar(clave_privada,mensaje)
    clave_privada = clave_privada.tr_s("[","").tr_s("]","").split(",")
    require 'digest'
    resumen = Digest::MD5.new # =>#<Digest::MD5>
    resumen.update mensaje
    resumen = resumen.to_s.unpack("a4a4a4a4a4a4a4a4")
    firma = []
    resumen.each do |i|
      #debugger
      firma.append(power_mod(i.to_s.to_i(16),clave_privada[1].to_i,clave_privada[0].to_i))

    end
    return firma.to_s.unpack("h*")[0]

  end


  private
  def  ver_firma(clave_publica,resumen,mensaje)

    clave_publica = clave_publica.tr_s("[","").tr_s("]","").split(",")
    resumen = [resumen].pack("h*").tr_s("[","").tr_s("]","").split(",")
    puts resumen.to_s
    salida = ""
    resumen.each do |i|
      a = (power_mod(i.to_i,clave_publica[1].to_i,clave_publica[0].to_i).to_s(16))
      while a.length<4
        a ="0"+a
      end
      salida+=a
    end

    require 'digest'
    md5 = Digest::MD5.new               # =>#<Digest::MD5>
    md5.update mensaje
    puts salida,md5.to_s
    puts salida==md5.to_s
    return salida==md5.to_s


  end

  private
  def power_mod(mensaje_entero,b,n)

    b = b.to_s(2).split("")
    z = 1
    b.each do |i|
      if i == "1"
        z = ((z**2)*mensaje_entero)%n
      else
        z=(z**2)%n
      end
    end
    return z
  end
end
