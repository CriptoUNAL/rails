class ChangeColumn2 < ActiveRecord::Migration[5.2]
  def change
    change_table :messages do |t|
      #t.change :destinatario, :integer
    end
  end
end
