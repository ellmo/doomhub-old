class MapImage < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :map
  belongs_to :user

  delegate :project, :to => :map

#=======
#= ATTR
#=====

  attr_accessible :author_id, :author_type, :map_id, :name, :image, :image_file_name

#============
#= PAPERCLIP
#==========

  has_attached_file :image,
                    :keep_old_files => true,
                    :styles => { :thumb => "240x150", :medium => "320x200" },
                    :url => Settings.paperclip.project.map.image.storage_url,
                    :path => ( Rails.env.production? ? :url : Settings.paperclip.project.map.image.storage_path )



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
  ALLOWED_MIMES = ["image/jpeg", "image/png", "image/tiff"]

  validate :check_attachment

  def check_attachment
    if (MIME::Types.type_for(image_file_name).map(&:to_s) & ALLOWED_MIMES).empty?
      errors[:wadfile] << "File must be a valid JPG / PNG / TIFF image"
    end
    if image.size > 1.megabyte
      errors[:wadfile] << "File must not be over 1 MB"
    end
  end


end
