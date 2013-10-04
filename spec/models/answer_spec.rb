require 'spec_helper'

describe Answer do
  it { should belong_to :post }
  it { should belong_to :user }
  it { should have_many :votes }
  it { should validate_presence_of :content }
  it { should ensure_length_of(:content).is_at_most(1000) }

  it 'should sort by total points' do
    @post = create(:post)
    @answer1 = create(:answer, post_id: @post.id )
    @answer2 = create(:answer, post_id: @post.id )
    @answer3 = create(:answer, post_id: @post.id )
    @answer3.votes.create
    2.times { @answer1.votes.create }
    Answer.ranked.should eq [@answer1, @answer3, @answer2]
  end
end
