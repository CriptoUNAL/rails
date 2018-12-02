class AddFirmaToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :firma, :string
  end
end
