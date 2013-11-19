class CreateFileLinks < ActiveRecord::Migration
  def change
    create_table :file_links do |t|
      t.integer :file_linkable_id
      t.string :file_linkable_type
      t.integer :author_id
      t.string :author_type
      t.string :url

      t.timestamps
    end
  end
end
