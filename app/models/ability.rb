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
      can [:read, :create], Project
      can [:destroy, :update], Project, :creator => {:id => user.id}
      can [:read, :create], Map
      can [:destroy, :update, :download], Map do |m|; m.author == user; end
      can :update, User, :user_id => user.id
    else
      can :read, Project
      can [:read, :download], Map
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
