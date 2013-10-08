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
    before do
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

    it 'should be able to be ranked by on karma' do
      User.by_rank.should eq [@user3, @user2, @user4, @user1]
    end

    it 'should have rank based on karma' do
      @user3.rank.should eq 1
      @user4.rank.should eq 2
      @user2.rank.should eq 2
      @user1.rank.should eq 4
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
end
