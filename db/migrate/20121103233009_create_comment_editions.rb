class CreateCommentEditions < ActiveRecord::Migration
  def change
    create_table :comment_editions do |t|
      t.integer :comment_id
      t.integer :user_id
      t.text :content_was

      t.timestamps
    end
  end
end
