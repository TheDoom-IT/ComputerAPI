class CreateComputers < ActiveRecord::Migration[5.2]
  def change
    create_table :computers do |t|
      t.string :name
      t.references :producer, foreign_key: true
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
