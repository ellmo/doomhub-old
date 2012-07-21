class ChangeAccessabilityFields < ActiveRecord::Migration
  def up
    remove_column :projects, :item_access_id
    add_column :projects, :public_view, :boolean, :null => false, :default => true
    add_column :projects, :public_join, :boolean, :null => false, :default => false
  end

  def down
    add_column :projects, :item_access_id, :integer, :null => false, :default => 1
    remove_column :projects, :public_view
    remove_column :projects, :public_join
  end
end
