class CriptoPropioController < ApplicationController


  def cifrar
    input = params[:input]
    key = params[:key]
    output = breaking(input, key)
    c_t_temp = mostrar(output)
    temp = Input.create(cipher:c_t_temp, tipo:"inventado")

    ans = {
      output: "#{c_t_temp}", id: temp.id
    }

    render json: ans
  end

  def descifrar
    output = params[:output]
    key = params[:key]
    out_temp = output.force_encoding("UTF-8").encode("ISO-8859-1")
    output_l = breaking_des(out_temp, key)
    c_t_temp = mostrar(output_l)


    ans = {
      input: "#{c_t_temp}"
    }

    render json: ans
  end


#desde aqui empieza los metodos, copiar y pegar esto para verificar

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
    puts
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
  def sb(array, inversa)
    sb = Hash[
        "0" => "63", "1" => "7c ", "2" => "77", "3" => "7b ", "4" => "f2 ", "5" => "6b ", "6" => "6f ", "7" => "c5 ", "8" => "30", "9" => "1", "a" => "67", "b" => "2b ", "c" => "fe ", "d" => "d7 ", "e" => "ab ", "f" => "76",
        "10" => "ca ", "11" => "82", "12" => "c9 ", "13" => "7d ", "14" => "fa ", "15" => "59", "16" => "47", "17" => "f0 ", "18" => "ad ", "19" => "d4 ", "1a" => "a2 ", "1b" => "af ", "1c" => "9c ", "1d" => "a4 ", "1e" => "72", "1f" => "c0",
        "20" => "b7 ", "21" => "fd ", "22" => "93", "23" => "26", "24" => "36", "25" => "3f ", "26" => "f7 ", "27" => "cc ", "28" => "34", "29" => "a5 ", "2a" => "e5 ", "2b" => "f1 ", "2c" => "71", "2d" => "d8 ", "2e" => "31", "2f" => "15",
        "30" => "4", "31" => "c7 ", "32" => "23", "33" => "c3 ", "34" => "18", "35" => "96", "36" => "5", "37" => "9a ", "38" => "7", "39" => "12", "3a" => "80", "3b" => "e2 ", "3c" => "eb ", "3d" => "27", "3e" => "b2 ", "3f" => "75",
        "40" => "9", "41" => "83", "42" => "2c ", "43" => "1a ", "44" => "1b ", "45" => "6e ", "46" => "5a ", "47" => "a0 ", "48" => "52", "49" => "3b ", "4a" => "d6 ", "4b" => "b3 ", "4c" => "29", "4d" => "e3 ", "4e" => "2f ", "4f" => "84",
        "50" => "53", "51" => "d1 ", "52" => "0", "53" => "ed ", "54" => "20", "55" => "fc ", "56" => "b1 ", "57" => "5b ", "58" => "6a ", "59" => "cb ", "5a" => "be ", "5b" => "39", "5c" => "4a ", "5d" => "4c ", "5e" => "58", "5f" => "cf",
        "60" => "d0 ", "61" => "ef ", "62" => "aa ", "63" => "fb ", "64" => "43", "65" => "4d ", "66" => "33", "67" => "85", "68" => "45", "69" => "f9 ", "6a" => "2", "6b" => "7f ", "6c" => "50", "6d" => "3c ", "6e" => "9f ", "6f" => "a8",
        "70" => "51", "71" => "a3 ", "72" => "40", "73" => "8f ", "74" => "92", "75" => "9d ", "76" => "38", "77" => "f5 ", "78" => "bc ", "79" => "b6 ", "7a" => "da ", "7b" => "21", "7c" => "10", "7d" => "ff ", "7e" => "f3 ", "7f" => "d2",
        "80" => "cd ", "81" => "0c ", "82" => "13", "83" => "ec ", "84" => "5f ", "85" => "97", "86" => "44", "87" => "17", "88" => "c4 ", "89" => "a7 ", "8a" => "7e ", "8b" => "3d ", "8c" => "64", "8d" => "5d ", "8e" => "19", "8f" => "73",
        "90" => "60", "91" => "81", "92" => "4f ", "93" => "dc ", "94" => "22", "95" => "2a ", "96" => "90", "97" => "88", "98" => "46", "99" => "ee ", "9a" => "b8 ", "9b" => "14", "9c" => "de ", "9d" => "5e ", "9e" => "0b ", "9f" => "db",
        "a0" => "e0 ", "a1" => "32", "a2" => "3a ", "a3" => "0a ", "a4" => "49", "a5" => "6", "a6" => "24", "a7" => "5c ", "a8" => "c2 ", "a9" => "d3 ", "aa" => "ac ", "ab" => "62", "ac" => "91", "ad" => "95", "ae" => "e4 ", "af" => "79",
        "b0" => "e7 ", "b1" => "c8 ", "b2" => "37", "b3" => "6d ", "b4" => "8d ", "b5" => "d5 ", "b6" => "4e ", "b7" => "a9 ", "b8" => "6c ", "b9" => "56", "ba" => "f4 ", "bb" => "ea ", "bc" => "65", "bd" => "7a ", "be" => "ae ", "bf" => "8",
        "c0" => "ba ", "c1" => "78", "c2" => "25", "c3" => "2e ", "c4" => "1c ", "c5" => "a6 ", "c6" => "b4 ", "c7" => "c6 ", "c8" => "e8 ", "c9" => "dd ", "ca" => "74", "cb" => "1f ", "cc" => "4b ", "cd" => "bd ", "ce" => "8b ", "cf" => "8a",
        "d0" => "70", "d1" => "3e ", "d2" => "b5 ", "d3" => "66", "d4" => "48", "d5" => "3", "d6" => "f6 ", "d7" => "0e ", "d8" => "61", "d9" => "35", "da" => "57", "db" => "b9 ", "dc" => "86", "dd" => "c1 ", "de" => "1d ", "df" => "9e",
        "e0" => "e1 ", "e1" => "f8 ", "e2" => "98", "e3" => "11", "e4" => "69", "e5" => "d9 ", "e6" => "8e ", "e7" => "94", "e8" => "9b ", "e9" => "1e ", "ea" => "87", "eb" => "e9 ", "ec" => "ce ", "ed" => "55", "ee" => "28", "ef" => "df",
        "f0" => "8c ", "f1" => "a1 ", "f2" => "89", "f3" => "0d ", "f4" => "bf ", "f5" => "e6 ", "f6" => "42", "f7" => "68", "f8" => "41", "f9" => "99", "fa" => "2d ", "fb" => "0f ", "fc" => "b0 ", "fd" => "54", "fe" => "bb ", "ff" => "16"]

    sb_i = Hash[
        "0" => "52", "1" => "9", "2" => "6a ", "3" => "d5 ", "4" => "30", "5" => "36", "6" => "a5 ", "7" => "38", "8" => "bf ", "9" => "40", "a" => "a3 ", "b" => "9e ", "c" => "81", "d" => "f3 ", "e" => "d7 ", "f" => "fb",
        "10" => "7c ", "11" => "e3 ", "12" => "39", "13" => "82", "14" => "9b ", "15" => "2f ", "16" => "ff ", "17" => "87", "18" => "34", "19" => "8e ", "1a" => "43", "1b" => "44", "1c" => "c4 ", "1d" => "de ", "1e" => "e9 ", "1f" => "cb",
        "20" => "54", "21" => "7b ", "22" => "94", "23" => "32", "24" => "a6 ", "25" => "c2 ", "26" => "23", "27" => "3d ", "28" => "ee ", "29" => "4c ", "2a" => "95", "2b" => "0b ", "2c" => "42", "2d" => "fa ", "2e" => "c3 ", "2f" => "4e",
        "30" => "8", "31" => "2e ", "32" => "a1 ", "33" => "66", "34" => "28", "35" => "d9 ", "36" => "24", "37" => "b2 ", "38" => "76", "39" => "5b ", "3a" => "a2 ", "3b" => "49", "3c" => "6d ", "3d" => "8b ", "3e" => "d1 ", "3f" => "25",
        "40" => "72", "41" => "f8 ", "42" => "f6 ", "43" => "64", "44" => "86", "45" => "68", "46" => "98", "47" => "16", "48" => "d4 ", "49" => "a4 ", "4a" => "5c ", "4b" => "cc ", "4c" => "5d ", "4d" => "65", "4e" => "b6 ", "4f" => "92",
        "50" => "6c ", "51" => "70", "52" => "48", "53" => "50", "54" => "fd ", "55" => "ed ", "56" => "b9 ", "57" => "da ", "58" => "5e ", "59" => "15", "5a" => "46", "5b" => "57", "5c" => "a7 ", "5d" => "8d ", "5e" => "9d ", "5f" => "84",
        "60" => "90", "61" => "d8 ", "62" => "ab ", "63" => "0", "64" => "8c ", "65" => "bc ", "66" => "d3 ", "67" => "0a ", "68" => "f7 ", "69" => "e4 ", "6a" => "58", "6b" => "5", "6c" => "b8 ", "6d" => "b3 ", "6e" => "45", "6f" => "6",
        "70" => "d0 ", "71" => "2c ", "72" => "1e ", "73" => "8f ", "74" => "ca ", "75" => "3f ", "76" => "0f ", "77" => "2", "78" => "c1 ", "79" => "af ", "7a" => "bd ", "7b" => "3", "7c" => "1", "7d" => "13", "7e" => "8a ", "7f" => "6b",
        "80" => "3a ", "81" => "91", "82" => "11", "83" => "41", "84" => "4f ", "85" => "67", "86" => "dc ", "87" => "ea ", "88" => "97", "89" => "f2 ", "8a" => "cf ", "8b" => "ce ", "8c" => "f0 ", "8d" => "b4 ", "8e" => "e6 ", "8f" => "73",
        "90" => "96", "91" => "ac ", "92" => "74", "93" => "22", "94" => "e7 ", "95" => "ad ", "96" => "35", "97" => "85", "98" => "e2 ", "99" => "f9 ", "9a" => "37", "9b" => "e8 ", "9c" => "1c ", "9d" => "75", "9e" => "df ", "9f" => "6e",
        "a0" => "47", "a1" => "f1 ", "a2" => "1a ", "a3" => "71", "a4" => "1d ", "a5" => "29", "a6" => "c5 ", "a7" => "89", "a8" => "6f ", "a9" => "b7 ", "aa" => "62", "ab" => "0e ", "ac" => "aa ", "ad" => "18", "ae" => "be ", "af" => "1b",
        "b0" => "fc ", "b1" => "56", "b2" => "3e ", "b3" => "4b ", "b4" => "c6 ", "b5" => "d2 ", "b6" => "79", "b7" => "20", "b8" => "9a ", "b9" => "db ", "ba" => "c0 ", "bb" => "fe ", "bc" => "78", "bd" => "cd ", "be" => "5a ", "bf" => "f4",
        "c0" => "1f ", "c1" => "dd ", "c2" => "a8 ", "c3" => "33", "c4" => "88", "c5" => "7", "c6" => "c7 ", "c7" => "31", "c8" => "b1 ", "c9" => "12", "ca" => "10", "cb" => "59", "cc" => "27", "cd" => "80", "ce" => "ec ", "cf" => "5f",
        "d0" => "60", "d1" => "51", "d2" => "7f ", "d3" => "a9 ", "d4" => "19", "d5" => "b5 ", "d6" => "4a ", "d7" => "0d ", "d8" => "2d ", "d9" => "e5 ", "da" => "7a ", "db" => "9f ", "dc" => "93", "dd" => "c9 ", "de" => "9c ", "df" => "ef",
        "e0" => "a0 ", "e1" => "e0 ", "e2" => "3b ", "e3" => "4d ", "e4" => "ae ", "e5" => "2a ", "e6" => "f5 ", "e7" => "b0 ", "e8" => "c8 ", "e9" => "eb ", "ea" => "bb ", "eb" => "3c ", "ec" => "83", "ed" => "53", "ee" => "99", "ef" => "61",
        "f0" => "17", "f1" => "2b ", "f2" => "4", "f3" => "7e ", "f4" => "ba ", "f5" => "77", "f6" => "d6 ", "f7" => "26", "f8" => "e1 ", "f9" => "69", "fa" => "14", "fb" => "63", "fc" => "55", "fd" => "21", "fe" => "0c ", "ff" => "7d"]


    if inversa == 1
      for i in 0..7
        array[i] = sb_i[array[i]]
      end
    else
      for i in 0..7
        array[i] = sb[array[i]]
      end
    end

    return array
  end

  def breaking(msg, key)
    output = []
    puts key
    keys = key_gen(key)

    n = msg.length
    times = n/8
    rest = n%8
    extra = 0

    if rest > 0
      extra = 1
    end

    cont = 0
    index = 0

    until cont == times
      temp = []
      for i in 0..7
        temp.push(msg[index+i])
      end
      temp =temp.reduce(:+)

      output.push(sec_cifrado(temp, keys))

      temp = nil
      index += 8
      cont += 1
    end

    if extra == 1
      temp = []
      for i in 0..7
        if i > (rest-1)
          temp.push("&")
        else
          temp.push(msg[index+i])
        end
      end
      temp = temp.reduce(:+)

      output.push(sec_cifrado(temp, keys))

      temp = nil
    end

    return  output
  end

  def sec_cifrado(m, keys)
    m = to_hexa(m)
    puts "mensaje en hexa"
    print m
    puts
    per_lu1_o = [0, 1, 2, 3, 4, 5, 6, 7]
    per_lu1_d = [5, 7, 1, 6, 2, 4, 0, 3]
    per_rot_o = [0, 1, 2, 3, 4, 5, 6, 7]
    per_rot_d = [2, 3, 4, 5, 6, 7, 0, 1]
    per_lu2_o = [0, 1, 2, 3, 4, 5, 6, 7]
    per_lu2_d = [7, 4, 6, 2, 3, 0, 1, 5]
    m = lucifer(per_lu1_o, per_lu1_d, m)

    for cont in 0..14
      m = addroundkey(m, keys[cont])
      m = sb(m, 0)
      m = lucifer(per_rot_o, per_rot_d, m)
    end
    return lucifer(per_lu2_o, per_lu2_d, m)

  end

  def mostrar(text)
    c_text = text[0]
    
    if text.length > 1
      for i in 1..(text.length-1)
        c_text.concat(text[i])
      end
    end

    for i in 0..(c_text.length-1)
      c_text[i] = c_text[i].strip
    end

    bin = c_text.map.each {|num| num.delete(" ").hex.to_s(2)}
    cha = bin.map.each {|num| num.to_i(2).chr}
    c_t_temp = cha.reduce(:+)

    return c_t_temp.force_encoding("ISO-8859-1").encode("UTF-8")
  end



  def breaking_des(msg, key)
    output = []
    #msg = "hola señoras y señores"
    keys = key_gen(key)

    n = msg.length
    times = n/8
    rest = n%8
    extra = 0

    if rest > 0
      extra = 1
    end

    cont = 0
    index = 0

    until cont == times
      temp = []
      for i in 0..7
        temp.push(msg[index+i])
      end
      temp =temp.reduce(:+)

      output.push(sec_descifrado(temp, keys))

      temp = nil
      index += 8
      cont += 1
    end

    if extra == 1
      temp = []
      for i in 0..7
        if i > (rest-1)
          temp.push("&")
        else
          temp.push(msg[index+i])
        end
      end
      temp = temp.reduce(:+)

      output.push(sec_descifrado(temp, keys))

      temp = nil
    end

    return  output
  end

  def sec_descifrado(m, keys)
    m = to_hexa(m)
    per_lu1_o = [5, 7, 1, 6, 2, 4, 0, 3]
    per_lu1_d = [0, 1, 2, 3, 4, 5, 6, 7]
    per_rot_o = [2, 3, 4, 5, 6, 7, 0, 1]
    per_rot_d = [0, 1, 2, 3, 4, 5, 6, 7]
    per_lu2_o = [7, 4, 6, 2, 3, 0, 1, 5]
    per_lu2_d = [0, 1, 2, 3, 4, 5, 6, 7]
    m = lucifer(per_lu2_o, per_lu2_d, m)
    aux = 14
    for cont in 0..14
      m = lucifer(per_rot_o, per_rot_d, m)
      m = sb(m, 1)
      m = addroundkey(m, keys[aux-cont])
    end
    return lucifer(per_lu1_o, per_lu1_d, m)

  end

end