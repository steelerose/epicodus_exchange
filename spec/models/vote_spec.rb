require 'spec_helper'

describe Vote do
  it { should belong_to :votable }
  it { should respond_to :votable_id }
  it { should respond_to :votable_type }
  it { should belong_to :user }
  it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }

  it 'prevents a user from voting on their own post or answer' do
  	@user = create(:user)
  	@post = create(:post, user: @user)
  	Vote.create(votable: @post, user: @user).should eq false
  end
end
