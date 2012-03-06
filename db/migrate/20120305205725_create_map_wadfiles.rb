class CreateMapWadfiles < ActiveRecord::Migration
  def change
    create_table :map_wadfiles do |t|
      t.integer :map_id
      t.integer :author_id
      t.string :author_type
      t.string :name

      t.timestamps
    end
  end
end
