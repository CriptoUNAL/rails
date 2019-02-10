class User < ApplicationRecord
    validates :name, uniqueness: true, length: { minimum: 2, maximum: 10 }
    validates :password, length: { minimum: 2, maximum: 10 }
end
