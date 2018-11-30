class SingupLoginController < ApplicationController
    def register
        session[:current_user_id] = -1
        reset_session
        p_k, pr_k = generator()
        user = User.new(name: params[:user], password: params[:pass], public_key: p_k, private_key: pr_k)
        if user.valid?

            user.save
            msg = "Usuario creado"
            ans = {
                mensaje: "#{msg}", id: true, pri_k: p_k
            }
            session[:current_user_id] = user.id

        else

            msg = 'Usuario ya existe'
            ans = {
                mensaje: "#{msg}", id: false
            }

        end

        render json: ans
    end

    def login
        usuario = params[:user]
        pass = params[:pass]

        user = User.find_by(name: usuario)

        if user.nil?

            msg = 'Usuario no registrado'
            ans = {
                mensaje: "#{msg}", id: 0
            }

        else

            if user.password == pass

                msg = 'Bienvenido ' + user.name
                session[:current_user_id] = user.id
                ans = {
                    mensaje: "#{msg}", id: 1, pri_k:, user.private_key
                }
            else
                msg = 'contraseña incorrecta'
                ans = {
                    mensaje: "#{msg}", id: 0
                }
            end

        end


        render json: ans
    end
    
    def generator
        lis_num = 
        [104369, 104381, 104383, 104393, 104399, 104417, 104459, 104471, 104473, 104479, 104491, 
         104513, 104527, 104537, 104543, 104549, 104551, 104561, 104579, 104593, 104597, 104623, 
         104639, 104651, 104659, 104677, 104681, 156061, 156071, 156089, 156109, 156119, 156127, 
         156131, 156139, 156151, 156157, 156217, 156227, 156229, 156241, 156253, 156257, 156259, 
         156269, 156307, 156319, 192037, 192043, 192047, 192053, 192091, 192097, 192103, 192113, 
         192121, 192133, 192149, 192161, 192173, 192187, 192191, 192193, 195163, 195193, 195197, 
         195203, 195229, 195241, 195253, 195259, 195271, 195277, 195281, 195311, 195319, 195329, 
         195341, 195343, 195353, 195359, 195389, 163871, 163883, 163901, 163909, 163927, 163973, 
         163979, 163981, 163987, 163991, 163993, 163997, 164011, 164023, 164039, 164051, 164057, 
         155893]

         other_lis = 
         [200033, 200041, 200063, 200087, 200117, 200131, 200153, 200159, 200171, 200177, 200183, 
          200191, 200201, 200227, 200231, 200237, 200257, 200273, 200293, 200297, 200323, 216347, 
          216371, 216373, 216379, 216397, 216401, 216421, 216431, 216451, 216481, 216493, 216509, 
          216523, 216551, 216553, 216569, 223051, 223061, 223063, 223087, 223099, 223103, 223129, 
          223133, 223151, 223207, 223211, 223217, 223219, 223229, 223241, 223243, 223247, 223253, 
          223259, 223273, 223277, 223283, 299701, 299711, 299723, 299731, 299743, 299749, 299771, 
          299777, 299807, 299843, 299857, 299861, 299881, 299891, 299903, 299909, 299933, 299941, 
          299951, 299969, 299977, 299983, 299993, 282713, 282767, 282769, 282773, 282797, 282809, 
          282827, 282833, 282847, 282851, 282869, 282881, 282889, 282907, 282911, 282913, 282917, 
          282959]

         p = lis_num[rand(99)]
         q = other_lis[rand(99)]
         n = p*q
         fi_n = (p-1)*(q-1)
         temp = 0
         while temp != 1
            e = rand(fi_n)
            temp = fi_n.gcd(e)
         end

        #  puts "valor de p: #{p}" 
        #  puts "valor de q: #{q}"
        #  puts "valor de n: #{n}"
        #  puts "valor de fi: #{fi_n}"
        #  puts "valor de e: #{e}"

         d = EEA(e,fi_n)
         k_p = [n,e]
         k_pr = [n,d]

         puts "clave publica #{k_p}" 
         puts "clave privada #{k_pr}"
         
         return k_p, k_pr
    end

    def EEA(a,b)
        s = [1,0]
        t = [0,1]
        if(a<b)
            r = [b,a]
        else
            r = [a,b]
        end
        qu = r[0]/r[1]
        ans = []
        while (r[1] !=0 )
            tem = s[1]
            s[1] = s[0] - (qu * s[1])
            s[0] = tem
            tem = t[1]
            t[1] = t[0] - (qu * t[1])
            t[0] = tem
            tem = r[0] % r[1]
            r[0] = r[1]
            r[1] = tem
            if r[1] == 1
                ans = [s[1], t[1]]
            end
            if r[1] == 0
                break
            end
            qu = r[0]/r[1]
        end
        if (ans[1]<0)
            ans[1] = ans[1] + t[1]
        end
        return ans[1]
        
    end

end
