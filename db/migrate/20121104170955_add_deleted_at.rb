class AddDeletedAt < ActiveRecord::Migration
  def up
    add_column :comments, :deleted_at, :datetime
    add_column :projects, :deleted_at, :datetime
    add_column :maps, :deleted_at, :datetime
    add_column :map_images, :deleted_at, :datetime
    add_column :map_wadfiles, :deleted_at, :datetime
    add_column :news, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime
  end

  def down
    remove_column :comments, :deleted_at
    remove_column :projects, :deleted_at
    remove_column :maps, :deleted_at
    remove_column :map_images, :deleted_at
    remove_column :map_wadfiles, :deleted_at
    remove_column :news, :deleted_at
    remove_column :user, :deleted_at
  end
end
