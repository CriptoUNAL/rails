Rails.application.routes.draw do
  
  post 'inventado/cifrar', to: 'cripto_propio#cifrar'
  post 'inventado/descifrar', to: 'cripto_propio#descifrar'
  
  post 'des/cifrar'
  post 'des/descifrar'
  
  get 'rsa/primos'

  root 'home#index'
  get 'cipher_text', to: 'home#consultar_cipher'
  get 'firma', to: 'home#signature'
  
  get 'joli', to: 'claves#selector'
end
