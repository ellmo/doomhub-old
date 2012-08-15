class AddWidthAndHeightToMapImages < ActiveRecord::Migration
  def change
    add_column :map_images, :width, :integer
    add_column :map_images, :height, :integer
  end
end
