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

  #function addround key
  def addroundkey(m, k)
    temp = [0, 1, 2, 3, 4, 5, 6, 7]

    for i in 0..7
      temp[i] = (m[i].to_i(16) ^ k[i].to_i(16)).to_s(16)
    end
    return temp
  end

  #keygenerator
  def key_gen(key)
    key = to_hexa(key)
    #si es la primera vez que ingresa la clave se hace la seleccion de los 8 caracteres a usar
    if key.length == 16
      key_temp = [0, 1, 2, 4, 5, 6, 7]
      aux = 0
      i = 0
      until i >= 7
        key_temp[i] = key[aux]
        i += 1
        aux += 1
        key_temp[i] = key[aux]
        aux += 3
        i += 1
      end
    else
      key_temp = key
    end
    keys = [16]
    keys[0] = key_temp
    puts

    for i in 1..14
      # 0 1 2 3 4 5 6 7
      # 5 6 7 0 1 2 3 4
      right_shift_o = [0, 1, 2, 3, 4, 5, 6, 7]
      right_shift_d = [1, 2, 3, 4, 5, 6, 7, 0]

      key_temp = lucifer(right_shift_o, right_shift_d, key_temp)

      aux = [key_temp[1], key_temp[2], key_temp[3]]

      for j in 1..3
        key_temp[j] = key_temp[j + 3]
        key_temp[j + 3] = aux[j - 1]
      end

      keys[i] = key_temp
      key = keys[i]
    end

    return keys
  end

  #Convert string to hexa array
  def to_hexa(word)
    asqui = word.each_byte.to_a
    #print asqui

    #transformar a hexa
    return asqui.map.each {|num| num.to_s(16)}
  end

  #permutaciones lucifer
  def lucifer (origen, destino, array)
    per_lu_o = origen
    per_lu_d = destino
    templ = [0, 1, 2, 3, 4, 5, 6, 7]

    #permutacion lucifer
    n = array.length - 1

    for i in 0..n
      templ[per_lu_d[i].to_i] = array[per_lu_o[i].to_i]
    end

    return templ

  end

  #transformacion sb
  def sb(array)

    return perm
  end
end