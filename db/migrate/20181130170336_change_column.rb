class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
    change_table :messages do |t|
      t.change :remitente, :integer
      t.change :destinatario, :integer
    end
  end
end
