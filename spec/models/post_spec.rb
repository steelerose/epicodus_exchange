require 'spec_helper'

describe Post do
  it { should have_many :votes }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should respond_to :content }
  it { should respond_to :name }
  it { should respond_to :answered }
  it { should respond_to :points }
  it { should belong_to :user }
  it { should validate_presence_of :content }
  it { should ensure_length_of(:content).is_at_most(5000) }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(60) }
  it { should validate_presence_of :user_id }

  describe 'custom \'all\' methods' do
    before do
      @post1 = create(:post, content: 'I have baz for you', created_at: 100.days.ago)
      @post2 = create(:post, content: 'Baz for you too', created_at: 10.days.ago, answered: 't')
      @post3 = create(:post, created_at: 50.days.ago)
      @post4 = create(:post, content: 'many happy bazzies', created_at: 70.days.ago, answered: 't')
      @post1.votes.create(user_id: 1)
      @post4.votes.create(user_id: 1)
    end

    it 'should return all unanswered posts, ranked by points' do
      Post.unanswered.should eq [@post1, @post3]
    end

    it 'should return all answered posts, ranked by points' do
      Post.all.should eq [@post2, @post3, @post4, @post1]
    end

    it 'should sort by total points' do
      @post1.votes.create(user_id: 1)
      @post1.votes.create(user_id: 2)
      @post1.votes.create(user_id: 3)
      @post3.votes.create(user_id: 1)
      @post3.votes.create(user_id: 2)
      @post3.votes.create(user_id: 3)
      @post3.votes.create(user_id: 4)
      @post2.votes.create(user_id: 1)
      @post2.votes.create(user_id: 2)
      Post.by_points.should eq [@post3, @post1, @post2, @post4]
    end

    it 'should sort by most recent (default .all method)' do
      Post.all.should eq [@post2, @post3, @post4, @post1]
    end

    describe 'search post content' do

      it 'should return all posts with content matching a requested keyword, regardless of case' do
        Post.search('bAz').should eq [@post2, @post1]
      end

      it 'should not return a post more than once (unique array)' do
        Post.search('baz baz').should eq [@post2, @post1]
      end

      it 'should return all posts with content matching requested keywords (testing more than one keyword)' do
        Post.search('baz happy').should eq [@post2, @post1, @post4]
      end
    end
  end

  it 'should start with 60 points' do
    @post = create(:post)
    @post.points.should eq 60
  end

  it 'should have total points equal to points plus number of votes' do
    @post = create(:post)
    @post.votes.create(user_id: 1)
    @post.points.should eq 61
  end

  it 'should lose 2 points every minute for the first 30 minutes' do
    @post = create(:post, created_at: 15.minutes.ago)
    @post.points.should eq 30
  end

  it 'should stop losing points after 30 minutes' do
    @post = create(:post, created_at: 1.hour.ago)
    @post.votes.create(user_id: 1)
    @post.votes.create(user_id: 2)
    @post.votes.create(user_id: 3)
    @post.votes.create(user_id: 4)
    @post.votes.create(user_id: 5)
    @post.points.should eq 5
  end
end
