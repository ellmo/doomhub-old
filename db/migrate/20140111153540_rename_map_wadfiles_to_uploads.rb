class RenameMapWadfilesToUploads < ActiveRecord::Migration
  def change
    rename_table :map_wadfiles, :uploads
  end
end
