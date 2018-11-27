class RsaController < ApplicationController
  def primos
  end
  def cifrar(clave_publica,mensaje) #retona una cadena de bits, que reprecetan texto cifrado
    n = clave_publica[1].to_s(2)
    cifrado = ""
    mensaje.length.times do |letra|
      letra_cifrada = power_mod(mensaje[letra].ord,clave_publica[0],clave_publica[1]).to_s(2)
      #puts power_mod(mensaje[letra].ord,clave_publica[0],clave_publica[1])
      while letra_cifrada.length<n.length
        letra_cifrada="0"+letra_cifrada
      end
      cifrado += letra_cifrada
    end
    return cifrado
  end

  def  descifrar(clave_privada,texto_cifrado) #el texto cifrado tiene que ser una cadena de bits
    n = clave_privada[1].to_s(2)
    texto = ""
    i = 0
    (texto_cifrado.length/n.length).times do |letra|
      letra_des = texto_cifrado[(letra)*(n.length)...(letra+1)*n.length]
      #puts letra_des.to_i(2)
      texto+=power_mod(letra_des.to_i(2),clave_privada[0],clave_privada[1]).chr
    end
    return texto
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
