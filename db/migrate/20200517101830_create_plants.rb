class CreatePlants < ActiveRecord::Migration[6.0]
  def change
    create_table :plants do |t|
      t.string :name
      t.string :name_latin
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :plants, [:user_id, :name_latin]
  end
end
