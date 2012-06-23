class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.superadmin?
      can :manage, :all
    elsif user.admin?
      can :manage, :all
      cannot :manage, User
      can :update, User, :user_id => user.id
    elsif user.regular?
      # projects
      can :create, Project
      can :read, Project, Project.readable_by(user) do |p|
        p.users.include? user or p.item_access_id != 3
      end
      can [:destroy, :update], Project, :creator => {:id => user.id}
      # maps
      can :read, Map
      can :create, Map, :project_id => Project.mappable_by(user).map(&:id)
      can [:destroy, :update], Map do |m|; m.author == user; end
      # map wadfiles
      can [:read, :create], MapWadfile, :map => {:project_id => Project.mappable_by(user).map(&:id)}
      can [:destroy, :update], MapWadfile do |mw|; mw.author == user; end
      can :download, MapWadfile, :map => {:project_id => Project.mappable_by(user).map(&:id)}
      # users
      can [:update, :show], User, :id => user.id
    else
      can :show, User, :id => nil
      can :read, Project, :item_access_id => 1
      can :read, Map
      can [:read, :download], MapWadfile
    end

  end
end
