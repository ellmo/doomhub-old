class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :url_name, :use => [:slugged, :history]

  belongs_to :game
  belongs_to :source_port

  has_many :maps
end
