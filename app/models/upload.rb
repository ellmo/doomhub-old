class Upload < ActiveRecord::Base

  acts_as_paranoid

#========
#= ASSOC
#======

  belongs_to :map
  belongs_to :authorable, polymorphic: true

  delegate :project, to: :map

#=======
#= ATTR
#=====

  # Setup accessible (or protected) attributes for your model
  attr_accessible :archive, :name

#============
#= PAPERCLIP
#==========
  ALLOWED_MIMES = ["application/zip", "application/x-7z-compressed", "application/x-rar-compressed"]

  has_attached_file :archive,
                    :keep_old_files => true,
                    :url => ":path",
                    :path => Settings.paperclip.project.map.archive.storage_path

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
  validate :check_if_can_add_to_map

  def check_attachment
    if (MIME::Types.type_for(archive_file_name).map(&:to_s) & ALLOWED_MIMES).empty?
      errors[:archive] << "File must be a valid zip / rar / 7z achive"
    end
    if archive.size > 1.megabyte
      errors[:archive] << "File must not be over 1 MB"
    end
  end

  def check_if_can_add_to_map
    errors[:map] << 'Cannot add more than 5 uploads per map' \
      if map.uploads.count >= 5
  end

#==========
#= METHODS
#========

  def downloadable_by?(user)
    project.mappable_by?(user)
  end

end
