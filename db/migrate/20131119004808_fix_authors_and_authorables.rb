class FixAuthorsAndAuthorables < ActiveRecord::Migration
  def change
    remove_column :authors, :authorable_id
    remove_column :authors, :authorable_type
    add_column :authors, :login, :string
    rename_column :file_links, :author_id, :authorable_id
    rename_column :file_links, :author_type, :authorable_type
    rename_column :map_wadfiles, :author_id, :authorable_id
    rename_column :map_wadfiles, :author_type, :authorable_type
    rename_column :maps, :author_id, :authorable_id
    rename_column :maps, :author_type, :authorable_type
  end
end
