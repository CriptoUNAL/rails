Rails.application.routes.draw do
  get 'des/cifrar'
  get 'des/descifrar'
  get 'des/cifrar'
  get 'des/decifrar'
  root 'home#index'
end
