require 'spec_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'when admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to(:manage, Post.new, Answer.new, Comment.new, Vote.new) }
  end

  describe 'when non-admin user' do
    let (:user) { create(:user) }

    it { should be_able_to(:read, Post.new, Answer.new, Comment.new, Vote.new) }
    it { should be_able_to(:create, Post.new(user: user), Answer.new(user: user), Comment.new(user: user), Vote.new(user: user)) }

    describe 'interacting with own content' do

      it { should be_able_to(:manage, Post.new(user: user), Answer.new(user: user), Comment.new(user: user), Vote.new(user: user)) }
    end

    describe 'interacting with other user\'s content' do

      it { should_not be_able_to(:update, Post.new, Answer.new, Comment.new, Vote.new) }
      it { should_not be_able_to(:destroy, Post.new, Answer.new, Comment.new, Vote.new) }
    end
  end

  describe 'when guest (no user account)' do
    let(:user) { nil }

    it { should be_able_to(:read, Post.new, Answer.new, Comment.new, Vote.new) }
    it { should_not be_able_to(:create, Post.new, Answer.new, Comment.new, Vote.new) }
    it { should_not be_able_to(:update, Post.new, Answer.new, Comment.new, Vote.new) }
    it { should_not be_able_to(:destroy, Post.new, Answer.new, Comment.new, Vote.new) }
  end
end








