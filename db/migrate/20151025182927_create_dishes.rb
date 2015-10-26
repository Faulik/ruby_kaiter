class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :title, limit: 45
      t.integer :sort_order
      t.text :description
      t.float :price
      t.text :type
      t.integer :children_ids, default: [], array: true
      t.integer :category_id
      
      t.timestamps null: false
    end
  end
end
