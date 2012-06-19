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
                    :keep_old_files => true,
                    :storage => :s3,
                    :bucket => "doomhub",
                    :url => "projects/:project_id/maps/:map_id/:name-:id.:extension",
                    :path => ":url",
                    :s3_permissions => :private,
                    :s3_credentials => {
                      :access_key_id => Settings.secret.s3.key,
                      :secret_access_key => Settings.secret.s3.access_key
                    }

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

  # validates_attachment_presence :wadfile, :message => "you have to attach a file"
  # validates_attachment_content_type :wadfile, :content_type => ["application/zip", "application/x-7z-compressed"]
  validate :check_content_type

  def check_content_type
    unless["application/zip", "application/x-7z-compressed"].include?(wadfile.content_type)
      errors[:wadfile] << "File is not a valid zip / 7z achive"
    end
  end
  # validates_attachment_size :wadfile, :less_than => 1.megabyte

#==========
#= METHODS
#========

  def downloadable?(user)
    user == self.author
  end

end
