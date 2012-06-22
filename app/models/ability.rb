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
      can :read, Project, Project.includes(:item_invites).where("projects.user_id = #{user.id} OR item_access_id = 1 OR (item_access_id = 3 AND projects.user_id = #{user.id}) OR (item_access_id = 2 AND item_invites.user_id = #{user.id})") do |p|
        p.creator == user or
        p.item_access_id == 1 or
        (p.item_access_id == 2 and p.users.include? user) or
        (p.item_access_id == 3 and p.creator == user)
      end
      can [:destroy, :update], Project, :creator => {:id => user.id}
      # maps
      can [:read, :create], Map
      can [:destroy, :update, :download], Map do |m|; m.author == user; end
      # map wadfiles
      can [:read, :create], MapWadfile
      can [:destroy, :update, :download], MapWadfile do |mw|; mw.author == user; end
      # users
      can [:update, :show], User, :id => user.id
    else
      can :read, Project, :item_access_id => 1
      can :read, Map
      can :read, MapWadfile
    end

  end
end
