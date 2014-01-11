class FileLink < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :file_linkable, polymorphic: true
  belongs_to :authorable, polymorphic: true

#=======
#= ATTR
#=====

  attr_accessible :url

#============
#= CALLBACKS
#==========

  validate :http_url

#============
#= METHODS
#==========

  def http_url
    errors[:url] << 'not a valid url' unless URI.parse(url).kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    errors[:url] << 'not a valid url'
  end
end
