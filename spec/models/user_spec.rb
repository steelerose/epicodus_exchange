require 'spec_helper'

describe User do
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :email }
  it { should respond_to :github }
  it { should respond_to :website }
  it { should respond_to :karma }
  it { should have_many :posts }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }

  it 'should update karma based on the number of votes on that user\'s answers' do
    user = create(:user)
    answer = create(:answer, user_id: user.id)
    new_id = user.id.to_i + 1
    answer.votes.create(user_id: new_id)
    user.update_karma.should eq 1
    user.reload
    user.karma.should eq 1
  end

  it 'has a method to update karma value' do
    #write test
  end

  describe 'user rank' do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @user4 = create(:user)
      answer4 = create(:answer, user: @user4)
      User.last.destroy
      answer2 = create(:answer, user: @user2)
      User.last.destroy
      answer3 = create(:answer, user: @user3)
      User.last.destroy
      answer3.votes.create(user: @user1)
      answer3.votes.create(user: @user2)
      @user3.update_karma
      answer4.votes.create(user: @user1)
      @user4.update_karma
      answer2.votes.create(user: @user1)
      @user2.update_karma
    end

    it 'should be able to be ranked by karma' do
      @user4.destroy
      User.by_rank.should eq [@user3, @user2, @user1]
    end

    it 'should have rank based on karma' do
      @user3.rank.should eq 1
      @user4.rank.should eq 2
      @user2.rank.should eq 2
      @user1.rank.should eq 4
    end
  end

  describe 'search user name and github' do
    before do
      @user1 = create(:user, first_name: 'someone', github: 'user1')
      @user2 = create(:user, first_name: 'somebody', github: 'user2')
      @user3 = create(:user, first_name: 'nobody', github: 'user3')
    end

    it 'should return all users with content matching a requested keyword, regardless of case' do
      User.search('someone').should eq [@user1]
    end

    it 'should not return a user more than once (unique array)' do
      User.search('foo').should eq [@user1, @user2, @user3]
    end

    it 'should return all users with content matching requested keywords (testing more than one keyword)' do
      User.search('someone somebody').should eq [@user1, @user2]
    end
  end

  it 'should validate format of website (has \'http://\' or similar format)' do
    user = create(:user, website: 'google.com')
    user.reload
    user.website.should eq 'http://google.com'
  end

  it 'should not modify websites in the correct format (starting with \'http://\')' do
    user = create(:user, website: 'http://omsi.edu')
    user.reload
    user.website.should eq 'http://omsi.edu'
  end

  it 'should not modify websites in the correct format (starting with \'https://\')' do
    user = create(:user, website: 'https://intel.com')
    user.reload
    user.website.should eq 'https://intel.com'
  end

  it 'should allow for empty website value' do
    user = create(:user, website: '')
    user.reload
    user.website.should eq ''
  end

  describe 'voted_on' do
    it 'should return true if the user has already voted on a post' do
      user = create(:user)
      post = create(:post)
      Vote.create(user: user, votable: post)
      user.voted_on(post).should be_true
    end

    it 'should return true if the user has already voted on an answer' do
      user = create(:user)
      answer = create(:answer)
      Vote.create(user: user, votable: answer)
      user.voted_on(answer).should be_true
    end

    it 'should return false if the user has not yet voted on a post' do
      user = create(:user)
      post = create(:post)
      user.voted_on(post).should be_false
    end

    it 'should return false if the user has not yet voted on an answer' do
      user = create(:user)
      answer = create(:answer)
      user.voted_on(answer).should be_false
    end
  end
end
