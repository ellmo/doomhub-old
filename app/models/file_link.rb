class FileLink < ActiveRecord::Base
  attr_accessible :url

  belongs_to :file_linkable, polymorphic: true
  belongs_to :authorable, polymorphic: true

  validate :http_url

  def http_url
    errors[:url] << 'not a valid url' unless URI.parse(url).kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    errors[:url] << 'not a valid url'
  end
end
