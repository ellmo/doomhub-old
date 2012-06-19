class MoveAttachmentFromMapToMapWadfile < ActiveRecord::Migration
  def self.up
    drop_attached_file :maps, :wadfile
    change_table :map_wadfiles do |t|
      t.has_attached_file :wadfile
    end
  end

  def self.down
    change_table :maps do |t|
      t.has_attached_file :wadfile
    end
    drop_attached_file :map_wadfiles, :wadfile
  end
end
