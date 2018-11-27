class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :public_key
      t.string :private_key

      t.timestamps
    end
  end
end
