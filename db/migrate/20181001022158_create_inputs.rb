class CreateInputs < ActiveRecord::Migration[5.2]
  def change
    create_table :inputs do |t|
      t.string :cipher
      t.string :tipo

      t.timestamps
    end
  end
end
