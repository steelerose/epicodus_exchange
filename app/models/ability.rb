class Ability
  include CanCan::Ability

  def initialize(user)
    can :crud, User, :id => user.id

    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :update, :all, :user_id => user.id
      can :create, Post,
    end


    
    alias_action :add, :create
  end
end


# Posts, Answers, Comments
# - not logged in: show, index
# - any log in: add, create
# - correct log in: edit, update, mark answered


# - admin: destroy, mark answered

# Users
# - not logged in: add, create, show, index
# - correct log in: edit, update, destroy


# - admin: destroy