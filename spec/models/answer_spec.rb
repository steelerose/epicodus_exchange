require 'spec_helper'

describe Answer do
  it { should belong_to :post }
  it { should belong_to :user }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should validate_presence_of :content }
  it { should ensure_length_of(:content).is_at_most(2500) }
  it { should validate_presence_of :user_id }

  it 'should sort by total points' do
    @post = create(:post)
    @answer1 = create(:answer, post_id: @post.id )
    @answer2 = create(:answer, post_id: @post.id )
    @answer3 = create(:answer, post_id: @post.id )
    @answer3.votes.create(user_id: 1)
    @answer1.votes.create(user_id: 1)
    @answer1.votes.create(user_id: 2)
    Answer.ranked.should eq [@answer1, @answer3, @answer2]
  end
end
