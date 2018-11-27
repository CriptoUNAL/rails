class RsaController < ApplicationController
  def primos
  end
  def cifrar(clave_publica,mensaje)
    n = clave_publica[1].to_s(2)
    cifrado = ""
    mensaje.length.times do |letra|
      letra_cifrada = power_mod(mensaje[letra].ord,clave_publica[0],clave_publica[1]).to_s(2)
      while letra_cifrada.length<n.length
        letra_cifrada="0"+letra_cifrada
      end
      cifrado += letra_cifrada
    end
    return to_hexa(cifrado)
  end

  def  descifrar(clave_privada,texto_cifrado)
    texto_cifrado = to_binary(texto_cifrado)
    n = clave_privada[1].to_s(2)
    texto = ""
    i = 0
    (texto_cifrado.length/n.length).times do |letra|
      letra_des = texto_cifrado[(letra)*(n.length)...(letra+1)*n.length]
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

  def to_hexa(mensaje)
    while mensaje.length%4 != 0
      mensaje = "0"+mensaje
    end
    mensaje = mensaje.split("")
    mensaje = mensaje.each_slice(4).to_a
    hexa = ""
    mensaje.each do |i|
      caracter = ""
      i.each { |j| caracter+=j}
      hexa+=caracter.to_i(2).to_s(16)
    end
    return hexa
  end

  def to_binary(mensaje)
    mensaje = mensaje.split("")
    bin = ""
    mensaje.each do |i|
      bit =  i.to_i(16).to_s(2)
      while bit.length<4
        bit="0"+bit
      end
      bin+= bit
    end
    return  bin
  end

end
