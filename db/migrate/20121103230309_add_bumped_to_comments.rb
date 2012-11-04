class AddBumpedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :bumped, :boolean, :null => false, :default => false
  end
end
