class Map < ActiveRecord::Base
  extend FriendlyId

  #########
  # ASSOC #
  #########

  belongs_to :project
  belongs_to :author, :polymorphic => true

  ###############
  # FRIENDLY_ID #
  ###############

  friendly_id :name, :use => [:slugged, :history]

  #############
  # PAPERCLIP #
  #############

  has_attached_file :wadfile,
                    :keep_old_files => true,
                    :storage => :s3,
                    :bucket => "doomhub",
                    :url => "projects/:project_id/maps/:map_id/:map_slug.:extension",
                    :path => ":url",
                    :s3_permissions => :private,
                    :s3_credentials => {
                      :access_key_id => Secret::S3_DOOMHUB_KEY,
                      :secret_access_key => Secret::S3_DOOMHUB_SECRET_KEY
                    }

  Paperclip.interpolates :project_id do |attachment, style|
    attachment.instance.project.id
  end

  Paperclip.interpolates :map_id do |attachment, style|
    attachment.instance.id
  end

  Paperclip.interpolates :map_slug do |attachment, style|
    m = attachment.instance
    "#{m.lump}_#{m.slug}"
  end

  ###############
  # VALIDATIONS #
  ###############

  validates :name, :presence => true
  validates_attachment_presence :wadfile
  validates_attachment_content_type :wadfile, :content_type => ["application/zip", "application/x-7z-compressed"]
  validates_attachment_size :wadfile, :less_than => 1.megabyte

  ###########
  # METHODS #
  ###########

  def downloadable?(user)
    user == self.author
  end

end
