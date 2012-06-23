class MapWadfile < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :map
  belongs_to :author, :polymorphic => true
  delegate :project, :to => :map

#============
#= PAPERCLIP
#==========

  has_attached_file :wadfile,
                    :keep_old_files => true

  Paperclip.interpolates :project_id do |attachment, style|
    attachment.instance.project.id
  end

  Paperclip.interpolates :map_id do |attachment, style|
    attachment.instance.map.id
  end

  Paperclip.interpolates :name do |attachment, style|
    attachment.instance.name.parameterize
  end

#=======
#= ATTR
#=====

  # Setup accessible (or protected) attributes for your model
  attr_accessible :wadfile, :name

#==============
#= VALIDATIONS
#============

  validate :check_attachment

  def check_attachment
    unless["application/zip", "application/x-7z-compressed"].include?(wadfile.content_type)
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
