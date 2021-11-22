class AddIndexForProducersOnName < ActiveRecord::Migration[5.2]
  def change
    add_index :producers, :name, unique: true
  end
end
