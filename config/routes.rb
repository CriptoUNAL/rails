Rails.application.routes.draw do
  
  post 'inventado/cifrar', to: 'cripto_propio#cifrar'
  post 'inventado/descifrar', to: 'cripto_propio#descifrar'
  
  post 'des/cifrar'
  post 'des/descifrar'
  
  get 'rsa/primos'

  root 'home#index'
  get 'cipher_text', to: 'home#consultar_cipher'
  get 'firma', to: 'home#signature'
  
  #singup
  post 'register', to: 'singup_login#register'

  #login
  post 'log', to: 'singup_login#login'

  #mensajes enviados y recibidos con un contacto
  post 'chats', to: 'messenger#mensajes'

  get 'registrarse', to: 'home#signup'

  #create_message
  post 'create', to: "messages#create"
  #comprobar_firma
  post 'comprobar/:id', to:"messages#comprobar_firma"

  #mensajes enviados y recibidos con un contacto
  post 'chats/:otra_persona', to: 'messages#chats'

  #editar_mensajes
  post 'edit/:id', to: 'messages#edit'
  post 'update', to: 'messages#update'


end
