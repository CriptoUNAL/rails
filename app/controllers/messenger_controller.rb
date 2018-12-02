class MessengerController < ApplicationController

    def mensajes
        #recibe el emisor y al receptor para buscar los mensajes que se han enviado entre ellos
        msgs = Message.all.where('remitente = ? AND destinatario = ?', params[:emisor], params[:receptor])
        
        render json: msgs
    end
end
