require 'spec_helper'

describe UsersController do
  subject { page }

  before do
    @user = create(:user)
    @post = create(:post, user: @user)
    @answer = create(:answer, user: @user)
    @comment = create(:comment, user: @user)
    new_id = @user.id.to_i + 1
    @answer.votes.create(user_id: new_id)
  end

  # SHOW PAGE
  describe 'Show page' do
    before { visit user_path(@user) }

    it { should have_content "#{@user.first_name} #{@user.last_name}" }

    it 'should list the user\'s posts' do
      @user.posts.each { |post| expect(page).to have_content post.name }
    end
  end




  # INDEX PAGE

end