class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :message
      #t.string :remitente
      #t.string :destinatario

      t.timestamps
    end
  end
end
