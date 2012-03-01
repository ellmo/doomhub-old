class AddAttachmentToMap < ActiveRecord::Migration
  def self.up
    change_table :maps do |t|
      t.has_attached_file :wadfile
    end
  end

  def self.down
    drop_attached_file :maps, :wadfile
  end
end
