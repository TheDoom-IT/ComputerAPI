class AddUniqueIndexForUsersOnKey < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :key, unique: true
  end
end
