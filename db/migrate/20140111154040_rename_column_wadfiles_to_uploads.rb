class RenameColumnWadfilesToUploads < ActiveRecord::Migration
  def change
    rename_column :uploads, :wadfile_file_name, :archive_file_name
    rename_column :uploads, :wadfile_content_type, :archive_content_type
    rename_column :uploads, :wadfile_file_size, :archive_file_size
    rename_column :uploads, :wadfile_updated_at, :archive_updated_at
  end
end
