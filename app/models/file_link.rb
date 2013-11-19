class FileLink < ActiveRecord::Base
  attr_accessible :url

  belongs_to :file_linkable, polymorphic: true
  belongs_to :author, polymorphic: true
end
