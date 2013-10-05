class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :manage, :all, user_id: user.id
    end

  end
end


# Posts, Answers, Comments
#    guest:         read
#    user:          read, create
#    correct user:  read, create, update
#    admin:         manage

# Users
#    guest:         read, create
#    correct user:  read, create, update, destroy
#    admin:         manage