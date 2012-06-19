class AddItemAccessIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :item_access_id, :integer, :null => false, :default => 1
  end
end
