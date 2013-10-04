require 'spec_helper'

describe User do
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :email }
  it { should respond_to :github }
  it { should respond_to :website }
  it { should have_many :posts }
  it { should have_many :answers }
  it { should have_many :comments }

  it 'should have karma equal to the number of votes on that user\'s answers' do
    @user = create(:user)
    @answer = create(:answer, user_id: @user.id)
    new_id = @user.id.to_i + 1
    @answer.votes.create(user_id: new_id)
    @user.karma.should eq 1
  end
end
