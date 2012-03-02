class AddUserRoleIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_role_id, :integer, :default => 3
  end
end
