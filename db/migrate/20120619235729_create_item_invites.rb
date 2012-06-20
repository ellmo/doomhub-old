class CreateItemInvites < ActiveRecord::Migration
  def change
    create_table :item_invites do |t|
      t.integer :user_id
      t.integer :invitable_id
      t.string :invitable_type

      t.timestamps
    end
  end
end
