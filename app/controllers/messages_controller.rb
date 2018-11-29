class MessagesController < ApplicationController

  def firmar(clave_privada,mensaje)
    require 'digest'
    resumen = Digest::MD5.new               # =>#<Digest::MD5>
    resumen.update mensaje
    resumen = resumen.to_s.unpack("a4a4a4a4a4a4a4a4")
    firma = []
    resumen.each do |i|
      firma.append(power_mod(i.to_s.to_i(16),clave_privada[1],clave_privada[0]))

    end
    return firma.to_s.unpack("h*")[0]

  end

  def  ver_firma(clave_publica,resumen,mensaje)

    resumen = [resumen].pack("h*").tr_s("[","").tr_s("]","").split(",")
    salida = ""
    resumen.each do |i|
      a = (power_mod(i.to_i,clave_publica[1],clave_publica[0]).to_s(16))
      while a.length<4
        a ="0"+a
      end
      salida+=a
    end

    require 'digest'
    md5 = Digest::MD5.new               # =>#<Digest::MD5>
    md5.update mensaje
    puts salida,md5.to_s

    return salida==md5.to_s


  end

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
