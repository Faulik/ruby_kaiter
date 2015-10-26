class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :filename, limit: 45

      t.timestamps null: false
    end
  end
end
