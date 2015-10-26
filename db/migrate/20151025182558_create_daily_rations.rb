class CreateDailyRations < ActiveRecord::Migration
  def change
    create_table :daily_rations do |t|
      t.float :price
      t.integer :quantity
      t.integer :person_id
      t.integer :daily_menu_id
      t.integer :sprint_id
      t.integer :dish_id

      t.timestamps null: false
    end
  end
end
