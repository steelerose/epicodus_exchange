require 'spec_helper'

# UPVOTE A POST
feature 'upvote a post' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    visit post_path @post
  end

  scenario 'by visiting links' do
    sign_in @user
    visit post_path @post
    click_link 'upvote'
    page.should have_title 'View post'
  end

  context 'on another user\'s post' do
    before :each do
      sign_in @user
      visit post_path @post
      click_link 'upvote'
    end

    scenario { should have_content '1 vote' }
    scenario { should_not have_link 'upvote' }
  end

  context 'on own post' do
    before :each do
      @post.update(user: @user)
      sign_in @user
      visit post_path @post
      page.driver.submit :post, votes_path(object: @post, sym: :Post), {}
    end

    scenario { should have_content 'not authorized' }
  end

  context 'as admin, on own post' do
    before :each do
      @user.update(admin: true)
      @post.update(user: @user)
      sign_in @user
      visit post_path @post
      page.driver.submit :post, votes_path(object: @post, sym: :Post), {}
    end

    scenario { should have_content 'not authorized' }
  end

  context 'after already upvoting' do
    before :each do
      sign_in @user
      visit post_path @post
      click_link 'upvote'
      page.driver.submit :post, votes_path(object: @post, sym: :Post), {}
    end

    scenario { should have_content 'not authorized' }

  end

  context 'without logging in' do
    before :each do
      page.driver.submit :post, votes_path(object: @post, sym: :Post), {}
    end

    scenario { should have_content 'Please sign in' }
  end
end

# UPVOTE AN ANSWER
feature 'upvote an answer' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    @answer = create(:answer, post: @post)
    visit post_path @post
  end

  scenario 'by visiting links' do
    sign_in @user
    visit post_path @post
    within('.answer-options') { click_link 'upvote' }
    page.should have_title 'View post'
  end

  context 'on another user\'s post' do
    before :each do
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'upvote' }
    end

    scenario 'increases the vote count' do
      within('.answer-options') { page.should have_content '1 vote' }
    end

    scenario 'upvote link is removed' do
      within('.answer-options') { page.should_not have_link 'upvote' }
    end
  end

  context 'on own answer' do
    before :each do
      @answer.update(user: @user)
      sign_in @user
      visit post_path @post
      page.driver.submit :post, votes_path(object: @answer, sym: :Answer), {}
    end

    scenario { should have_content 'not authorized' }
  end

  context 'as admin, on own answer' do
    before :each do
      @user.update(admin: true)
      @answer.update(user: @user)
      sign_in @user
      visit post_path @post
      page.driver.submit :post, votes_path(object: @answer, sym: :Answer), {}
    end

    scenario { should have_content 'not authorized' }
  end

  context 'after already upvoting' do
    before :each do
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'upvote' }
      page.driver.submit :post, votes_path(object: @answer, sym: :Answer), {}
    end

    scenario { should have_content 'not authorized' }

  end

  context 'without logging in' do
    before :each do
      page.driver.submit :post, votes_path(object: @answer, sym: :Answer), {}
    end

    scenario { should have_content 'Please sign in' }
  end
end

