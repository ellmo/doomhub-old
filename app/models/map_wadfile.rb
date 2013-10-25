class MapWadfile < ActiveRecord::Base

  acts_as_paranoid

#========
#= ASSOC
#======

  belongs_to :map
  belongs_to :author, :polymorphic => true

  delegate :project, :to => :map

#=======
#= ATTR
#=====

  # Setup accessible (or protected) attributes for your model
  attr_accessible :wadfile, :name

#============
#= PAPERCLIP
#==========
  ALLOWED_MIMES = ["application/zip", "application/x-7z-compressed"]

  has_attached_file :wadfile,
                    :keep_old_files => true,
                    :url => ":path",
                    :path => Settings.paperclip.project.map.wadfile.storage_path

  Paperclip.interpolates :project_id do |attachment, style|
    attachment.instance.project.id
  end

  Paperclip.interpolates :map_id do |attachment, style|
    attachment.instance.map.id
  end

  Paperclip.interpolates :name do |attachment, style|
    attachment.instance.name.parameterize
  end

#==============
#= VALIDATIONS
#============

  validate :name, :presence => true
  validate :check_attachment

  def check_attachment
    if (MIME::Types.type_for(wadfile_file_name).map(&:to_s) & ALLOWED_MIMES).empty?
      errors[:wadfile] << "File must be a valid zip / 7z achive"
    end
    if wadfile.size > 1.megabyte
      errors[:wadfile] << "File must not be over 1 MB"
    end
  end

#==========
#= METHODS
#========

  def downloadable_by?(user)
    project.mappable_by?(user)
  end

end
