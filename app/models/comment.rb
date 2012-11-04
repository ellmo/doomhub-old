class Comment < ActiveRecord::Base

  include Rails.application.routes.url_helpers

  acts_as_paranoid

#========
#= ASSOC
#======

  belongs_to :commentable, :polymorphic => true
  belongs_to :user, :with_deleted => true
  has_many :editions, :class_name => CommentEdition

#=======
#= ATTR
#=====

  attr_accessible :commentable_id, :commentable_type, :content, :user, :bumped

#============
#= CALLBACKS
#==========

  before_update :create_edition, :if => 'content_changed?'

#=========
#= SCOPES
#=======

  scope :bumped, where(:created_at != :updated_at, :bumped => true)
  scope :edited, where(:created_at != :updated_at, :bumped => false)

#==========
#= METHODS
#========

  def path
    polymorphic_path([commentable, self])
  end

  def bump!
    update_attribute :bumped, true
  end

  def edited?
    created_at != updated_at and !bumped?
  end

  def last_edit_author
    return nil unless edited?
    editions.last.user
  end

private

  def create_edition(author=user)
    editions.create :user => author, :content_was => content_was
    self.user_id = user_id_was
  end

end
