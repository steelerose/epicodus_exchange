require 'spec_helper'

describe VotesController do
  describe 'upvote button' do
    before do
      @post = create(:post)
      visit root_path
      click_link @post.name
    end

    it 'should add a vote to the database' do
      expect {click_link 'upvote'}.to change(Vote, :count).by(1)
    end

    it 'should have the appropriate post_id' do
      click_link 'upvote'
      Vote.first.votable_id.should eq @post.id
      Vote.first.votable_type.should eq 'Post'
    end
  end
end