require 'spec_helper'

describe VotesController do
  describe 'upvote button' do
    before do
      @user = create(:user)
      visit '/users/sign_in'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Sign in'
      @post = create(:post, user_id: 1)
      visit root_path
      click_link @post.name
    end

    it 'should add a vote to the database' do
      expect { click_link 'upvote' }.to change(Vote, :count).by(1)
    end

    it 'should have the appropriate post_id' do
      click_link 'upvote'
      Vote.first.votable_id.should eq @post.id
      Vote.first.votable_type.should eq 'Post'
    end

    it 'should only let you vote once per post' do
      click_link 'upvote'
      expect { click_link 'upvote' }.not_to change(Vote, :count)
    end

    it 'should only let you vote once per answer' do
      @post.answers.create(content: 'Solution to foo', user_id: 1)
      visit post_path(@post)
      find(:xpath, "(//a[text()='upvote'])[2]").click
      expect { find(:xpath, "(//a[text()='upvote'])[2]").click }.not_to change(Vote, :count)
    end
  end
end