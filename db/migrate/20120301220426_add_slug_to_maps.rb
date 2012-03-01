class AddSlugToMaps < ActiveRecord::Migration
  def change
    add_column :maps, :slug, :string
  end
end
