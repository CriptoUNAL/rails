Rails.application.routes.draw do
  
  post 'inventado/cifrar', to: 'cripto_propio#cifrar'
  post 'inventado/descifrar', to: 'cripto_propio#descifrar'

  get 'cipher_text', to: 'home#consultar_cipher'
  
  post 'des/cifrar'
  post 'des/descifrar'

  root 'home#index'
end
