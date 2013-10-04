require 'spec_helper'

describe Comment do
  it { should belong_to :answer }
  it { should belong_to :user }
  it { should validate_presence_of :content }
  it { should ensure_length_of(:content).is_at_most(500) }

  it 'should sort by date created' do
    @post = create(:post)
    @answer1 = create(:answer, post_id: @post.id )
    @comment1 = @answer1.comments.create(content: 'comment1', user_id: 1, created_at: 5.minutes.ago)
    @comment2 = @answer1.comments.create(content: 'comment2', user_id: 1)
    @comment3 = @answer1.comments.create(content: 'comment3', user_id: 1, created_at: 10.minutes.ago)
    Comment.all.should eq [@comment3, @comment1, @comment2]
  end
end