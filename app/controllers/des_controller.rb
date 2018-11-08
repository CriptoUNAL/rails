class DesController < ApplicationController
  
  def cifrar
    input = params[:input]
    key = params[:key]
    output = init(input,key,true)

    temp = Input.create(cipher: output, tipo:"des")
    ans = {
      output: "#{output}", id: temp.id
    }

    render json: ans
  end
  
  def descifrar
    output = params[:output]
    key = params[:key]
    
    output = init(output,key,false)
    ans = {
      input: "#{output}"
    }

    render json: ans
  end
    @@table_Pi=[
  58,	50,	42,	34,	26,	18,	10,	2,
  60,	52,	44,	36,	28,	20,	12,	4,
  62,	54,	46,	38,	30,	22,	14,	6,
  64,	56,	48,	40,	32,	24,	16,	8,
  57,	49,	41,	33,	25,	17,	9,	1,
  59,	51,	43,	35,	27,	19,	11,	3,
  61,	53,	45,	37,	29,	21,	13,	5,
  63,	55,	47,	39,	31,	23,	15,	7]

  @@table_Pi_inver = [
  40,	8,	48,	16,	56,	24,	64,	32,
  39,	7,	47,	15,	55,	23,	63,	31,
  38,	6,	46,	14,	54,	22,	62,	30,
  37,	5,	45,	13,	53,	21,	61,	29,
  36,	4,	44,	12,	52,	20,	60,	28,
  35,	3,	43,	11,	51,	19,	59,	27,
  34,	2,	42,	10,	50,	18,	58,	26,
  33,	1,	41,	9,	49,	17,	57,	25]

  @@table_PC1 =[
  57,	49,	41,	33,	25,	17,	9,
  1,	58,	50,	42,	34,	26,	18,
  10,	2,	59,	51,	43,	35,	27,
  19,	11,	3,	60,	52,	44,	36,
  63,	55,	47,	39,	31,	23,	15,
  7,	62,	54,	46,	38,	30,	22,
  14,	6,	61,	53,	45,	37,	29,
  21,	13,	5,	28,	20,	12,	4]

  @@table_PC2 = [
  14,	17,	11,	24,	1,	5,
  3,	28,	15,	6,	21,	10,
  23,	19,	12,	4,	26,	8,
  16,	7,	27,	20,	13,	2,
  41,	52,	31,	37,	47,	55,
  30,	40,	51,	45,	33,	48,
  44,	49,	39,	56,	34,	53,
  46,	42,	50,	36,	29,	32]

  @@corrimientos =[1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1]

  @@table_E = [
  32,	1,	2,	3,	4,	5,
  4,	5,	6,	7,	8,  9,
  8,	9,	10,	11,	12,	13,
  12,	13,	14,	15,	16,	17,
  16,	17,	18,	19,	20,	21,
  20,	21,	22,	23,	24,	25,
  24,	25,	26,	27,	28,	29,
  28,	29,	30,	31,	32,	1
  ]

  @@table_P = [
      16,7,20,21,29,12,28,17,
      1,15,23,26,5,18,31,10,
      2,8,24,14,32,27,3,9,
      19,13,30,6,22,11,4,25,
  ]

  @@S1_table =[
      [14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7],
      [0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8],
      [4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0],
      [15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13]
  ]

  @@S2_table =[
      [15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10],
      [3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5],
      [0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15],
      [13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9]
  ]
  @@S3_table =[
      [10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8],
      [13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1],
      [13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7],
      [1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12]
  ]
  @@S4_table =[
      [7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15],
      [13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9],
      [10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4],
      [3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14]
  ]
  @@S5_table =[
      [2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9],
      [14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6],
      [4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14],
      [11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3]
  ]
  @@S6_table =[
      [12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11],
      [10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8],
      [9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6],
      [4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13]
  ]
  @@S7_table =[
      [4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1],
      [13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6],
      [1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2],
      [6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12]
  ]
  @@S8_table =[
      [13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7],
      [1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2],
      [7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8],
      [2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11]
  ]

  @@tablesS=[@@S1_table,@@S2_table,@@S3_table,@@S4_table,@@S5_table,@@S6_table,@@S7_table,@@S8_table]

  def cifrar_DES(binary_plain_text,key)
    text = binary_plain_text
    keys = key_generator(key,true)
    text = per_PI(text)
    l_array = text[0...32]
    r_array = text[32...64]
    16.times()do |i|

      l_array_temp = r_array
      r_array_temp = per_E(r_array)
      r_array_temp = xor(keys[i],r_array_temp)
      r_array_temp = funcion(r_array_temp)
      r_array_temp = per_P(r_array_temp)
      r_array_temp = xor(l_array,r_array_temp)

      l_array=l_array_temp
      r_array=r_array_temp

    end
    text = r_array+l_array
    text = per_PI_inver(text)

    return text

  end

  def descifrar_DES(binary_plain_text,key)
    text = binary_plain_text
    keys = key_generator(key,true )
    text = per_PI(text)
    l_array = text[0...32]
    r_array = text[32...64]
    16.times()do |i|

      l_array_temp = r_array
      r_array_temp = per_E(r_array)
      r_array_temp = xor(keys[15-i],r_array_temp)
      r_array_temp = funcion(r_array_temp)
      r_array_temp = per_P(r_array_temp)
      r_array_temp = xor(l_array,r_array_temp)

      l_array=l_array_temp
      r_array=r_array_temp

    end
    text = r_array+l_array
    text = per_PI_inver(text)

    return text

  end

  def per_PI(array_text_binario)
    permut = []
    64.times do |i| permut.insert(i,array_text_binario[@@table_Pi[i]-1])  end
    return permut
  end

  def per_PI_inver(array_text_binario)
    permut = []
    64.times do |i| permut.insert(i,array_text_binario[@@table_Pi_inver[i]-1])  end
    return permut
  end

  def per_E(array_text_binario)
    permut = []
    48.times do |i| permut.insert(i,array_text_binario[@@table_E[i]-1])   end
    return permut
  end

  def per_P(array_text_binario)
    permut = []
    32.times do |i| permut.insert(i,array_text_binario[@@table_P[i]-1])   end
    return permut
  end

  def xor(key,array)
    permut = []
    n = array.length
    n.times do |i|
      if key[i]==array[i]
        permut.insert(i,0)
      else
        permut.insert(i,1)
      end
    end
    return permut
  end

  def coordenadas(array)
    6.times{|i| array[i]=array[i].to_s}
    y = (array[0]+array[5]).to_i(2)
    x = (array[1]+array[2]+array[3]+array[4]).to_i(2)
    return x,y
  end

  def funcion(array)
    a,b = 0,6; permut = ""
    8.times do |i|
      x,y = coordenadas(array[a...b])
      permut += (@@tablesS[i][y][x]+16).to_s(2);a+=6; b+=6
    end
    j=0
    8.times() { |i| permut[j]="-"; j+=5}
    permut.delete!("-")
    permut = permut.split("")
    32.times() {|i| permut[i]=permut[i].to_i}
    return permut
  end

  def key_generator(key,encriptar_bool)
    keys = []
    def per_PC1(key)
      permut = []
      56.times do |i| permut.insert(i,key[@@table_PC1[i]-1])  end
      return permut
    end

    def sb(key,encriptar_bool)
      c0 = key[0...28]
      d0 = key[28...56]

      if encriptar_bool
        c0.push(c0.shift)
        d0.push(d0.shift)
      else
        c0.insert(0,c0.pop)
        d0.insert(0,d0.pop)
      end
      return c0+d0
    end

    def per_PC2(key)
      permut = []
      48.times do |i| permut.insert(i,key[@@table_PC2[i]-1])  end
      return permut
    end
    ########################
    key = per_PC1(key)
    16.times()do|i|
      corrimientos = @@corrimientos[i]
      corrimientos.times(){ key = sb(key,encriptar_bool)}
      keys.insert(i,per_PC2(key))
    end
    return keys
  end

  def bloques (my_string)
    bloque = my_string.chars.each_slice(8).map(&:join)
    
    bloque_bytes = []

    #conversion a binario
    for i in (0..bloque.length-1)      
      bin = bloque[i].unpack('B*')
      bloque_bytes.push bin
    end
    return bloque_bytes

  end

  def to_bits (arr_byts)
    #paso a bits
    bytes = []
    for i in (0..arr_byts.length-1)
      arr_byts[i].each_char {|byte| bytes << byte.to_i()}
    end
    
    return bytes

  end

  def to_hexa(arr_bytes)
    #agrupacion por bits de caracter
    salida = ""
    8.times{|i|
      cadena = ""
      8.times{|j|
      cadena += arr_bytes[j+(8*i)].to_s()

      
      }
      if cadena.to_i(2).to_s(16).length==1
        salida += "0"+cadena.to_i(2).to_s(16)
      elsif cadena.to_i(2).to_s(16).length==0
        salida += "00"+cadena.to_i(2).to_s(16)
      else
      salida += cadena.to_i(2).to_s(16)
      end
    } 
    return salida
    
  end


  def to_string(arr_bytes)
  #agrupacion por bits de caracter
  cipher = []
  block_bin = arr_bytes.each_slice(8).to_a.map(&:join)

  #conversion a caracter
  for i in (0..block_bin.length-1)
    cipher << block_bin[i].to_i(2).chr
  end
  new_str = cipher.join()

  return new_str 
  end



  def init( entrada_text,key, cifrar_bool)

    key = bloques(key)
    key = to_bits(key[0])

    if cifrar_bool
    bloque = bloques(entrada_text)
    
  

    bloque.length.times{|i| 
    bloque[i]=to_bits(bloque[i])}
    while bloque[-1].length<64
        bloque[-1].push(0)
    end
    salida =""
    bloque.length.times{|i| 
    salida+=to_hexa(cifrar_DES(bloque[i],key))}

    return salida
    
    else
    bloque = entrada_text.to_i(16).to_s(2)

    while bloque.length% 64 !=0
        bloque="0"+bloque
    end 
    bloque =bloque.chars.each_slice(64).map(&:join)

    bloque.length.times{|i|
      bloque[i]=to_bits(bloque[i])
    }
    salida =""
    bloque.length.times{|i| 
    salida+=to_string(descifrar_DES(bloque[i],key))}
    return salida
    end

    

  end
end


