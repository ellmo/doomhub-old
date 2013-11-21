class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

#=============
#= SUPERADMIN
#===========
    if user.superadmin?
      can :manage, :all
#========
#= ADMIN
#======
    elsif user.admin?
      can :manage, :all
      cannot :manage, User
      can :manage, User, :user_id => user.id
#=========
#= LOGGED
#=======
    elsif user.regular?
  # projects
      can :create, Project
      can :read, Project do |p|
        p.users.include? user or p.creator == user or p.public_view
      end
      can [:destroy, :update], Project, :creator => {:id => user.id}
  # maps
      can :read, Map
      can :create, Map, :project_id => Project.mappable_by(user).map(&:id)
      can [:destroy, :update], Map do |m|; m.authorable == user; end
  # map images
      can :create, MapImage, map: {authorable: {id: user.id}, authorable_type: 'User'}
      can :auth_url, MapImage, :map => {:project_id => Project.readable_by(user).map(&:id)}
      can [:destroy, :update], MapImage do |mi|; mi.user == user; end
  # map wadfiles
      can [:read, :create], MapWadfile, map: {authorable: {id: user.id}, authorable_type: 'User'}
      can [:destroy, :update], MapWadfile do |mw|; mw.author == user; end
      can :download, MapWadfile, :map => {:project_id => Project.mappable_by(user).map(&:id)}
  # news
      can :read, News
  # comments
      can [:read, :create], Comment
      can [:update, :destroy], Comment, :user => {:id => user.id}
  # users
      can [:update, :show], User, :id => user.id
#=============
#= NOT LOGGED
#===========
    else
  # projects
      can :read, Project, :public_view => true
  # maps
      can :read, Map
  # map images
      can [:read, :auth_url], MapImage
  # map wadfiles
      can [:read, :download], MapWadfile
  # news
      can :read, News
  # comments
      can :read, Comment
  # users
      can :show, User, :id => nil
    end

  end
end
