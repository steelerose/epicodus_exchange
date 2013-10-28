class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif !user.id.nil?
      can :read, :all
      can :create, :all
      can :update, :all, user_id: user.id
      can :destroy, :all, user_id: user.id
    else
      can :read, :all
    end

    can :mark_answered, Post do |post|
      user.admin? || user == post.user
    end

    can :upvote, Post do |post|
      !user.id.nil? && user != post.user && !user.voted_on(post)
    end

    can :upvote, Answer do |answer|
      !user.id.nil? && user != answer.user && !user.voted_on(answer)
    end

  end
end

