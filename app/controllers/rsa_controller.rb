class RsaController < ApplicationController
  def primos
  end
  def cifrar(clave_publica,mensaje)
    puts mensaje.length
    ar = "b32"*((mensaje.length/3))
    mensaje = mensaje.unpack(ar)
    while mensaje[-1]==""
      mensaje.pop
    end
    texto_cifrado = []
    mensaje.each do |mensaje_32|
      texto_cifrado.append(power_mod(mensaje_32.to_i(2),clave_publica[1],clave_publica[0]))
    end
    return texto_cifrado.to_s.unpack("h*")

  end

  def  descifrar(clave_privada,texto_cifrado)
    texto_cifrado = texto_cifrado.pack("h*").tr_s("[","").tr_s("]","").split(",")
    salida = ""
    puts texto_cifrado.length,(power_mod(texto_cifrado[-1].to_i,clave_privada[1],clave_privada[0]))
    texto_cifrado.each do |text|
      temp =[]
      temp.append(power_mod(text.to_i,clave_privada[1],clave_privada[0]).to_s(2))
      while (temp[0].length)%8!=0
        temp[0] = "0"+temp[0]
      end
      salida = salida+temp.pack("b*")

    end
    puts salida
    return salida
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
