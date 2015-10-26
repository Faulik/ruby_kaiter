class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, limit: 45
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
