class CreateMapImages < ActiveRecord::Migration
  def change
    create_table :map_images do |t|
      t.integer :map_id
      t.integer :user_id
      t.string :name
      t.has_attached_file :image

      t.timestamps
    end
  end
end
