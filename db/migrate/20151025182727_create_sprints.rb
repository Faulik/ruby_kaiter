class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :title, limit:45
      t.date :started_at
      t.date :finished_at
      t.string :state

      t.timestamps null: false
    end
  end
end
