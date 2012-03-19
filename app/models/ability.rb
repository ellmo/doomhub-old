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
      can [:read, :create], Project
      can [:destroy, :update], Project, :creator => {:id => user.id}
      # maps
      can [:read, :create], Map
      can [:destroy, :update, :download], Map do |m|; m.author == user; end
      # map wadfiles
      can [:read, :create], MapWadfile
      can [:destroy, :update, :download], MapWadfile do |mw|; mw.author == user; end
      # users
      can :update, User, :user_id => user.id
    else
      can :read, Project
      can :read, Map
      can :read, MapWadfile
    end
    
  end
end
