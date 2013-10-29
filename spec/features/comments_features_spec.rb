require 'spec_helper'

# CREATE NEW COMMENT - POST
feature 'create new comment on a post' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    visit post_path @post
  end

  scenario 'by visiting links' do
    sign_in @user
    visit post_path @post
    within('.post-options') { click_link 'comment' }
    page.should have_title 'Comment'
  end

  context 'logged in, with valid information' do
    before :each do
      sign_in @user
      visit post_path @post
      within('.post-options') { click_link 'comment' }
      fill_in 'comment_content', with: 'My observation is...'
      click_button 'Submit'
    end

    scenario { should have_content 'Comment added' }
    scenario { should have_content 'My observation is...' }
    scenario { should have_content "#{@user.first_name} #{@user.last_name}" }
  end

  context 'logged in, with invalid information' do
    before :each do
      sign_in @user
      visit post_path @post
      within('.post-options') { click_link 'comment' }
      click_button 'Submit'
    end

    scenario { should_not have_content("#{@user.first_name} #{@user.last_name}") }
  end

  context 'not logged in' do
    scenario 'should not allow user to visit the new comment form' do
      visit new_comment_path(type: 'post', id: @post.id)
      page.should have_content 'Please sign in'
    end

    scenario 'should not allow user to create a comment' do
      page.driver.submit :post, comments_path(comment: { content: 'comment content', type: 'post', id: @post.id }), {}
      page.should have_content 'Please sign in'
    end
  end
end

# CREATE NEW COMMENT - ANSWER
feature 'create new comment on an answer' do
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
    within('.answer-options') { click_link 'comment' }
    page.should have_title 'Comment'
  end

  context 'logged in, with valid information' do
    before :each do
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'comment' }
      fill_in 'comment_content', with: 'My observation is...'
      click_button 'Submit'
    end

    scenario { should have_content 'Comment added' }
    scenario { should have_content 'My observation is...' }
    scenario { should have_content "#{@user.first_name} #{@user.last_name}" }
  end

  context 'logged in, with invalid information' do
    before :each do
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'comment' }
      click_button 'Submit'
    end

    scenario { should_not have_content("#{@user.first_name} #{@user.last_name}") }
  end

  context 'not logged in' do
    scenario 'should not allow user to visit the new comment form' do
      visit new_comment_path(type: 'answer', id: @answer.id)
      page.should have_content 'Please sign in'
    end

    scenario 'should not allow user to create a comment' do
      page.driver.submit :post, comments_path(comment: { content: 'comment content', type: 'answer', id: @answer.id }), {}
      page.should have_content 'Please sign in'
    end
  end
end

# DELETE COMMENT - POST
feature 'delete comment from a post' do
  subject { page }

  before :each do
    @user = create(:user)
    @user2 = create(:user)
    @post = create(:post)
    @comment = Comment.create(content: 'my comment', commentable: @post, user: @user2)
  end

  scenario 'by visiting links' do
    @comment.update(user: @user)
    sign_in @user
    visit post_path @post
    within('.post-comments') { click_link 'delete' }
    page.should have_title 'View post'
  end

  context 'as admin' do
    before :each do
      @user.update(admin: true)
      sign_in @user
      visit post_path @post
      within('.post-comments') { click_link 'delete' }
    end

    scenario { should_not have_content @comment.content }
    scenario { should have_content 'Comment deleted' }
  end

  context 'as comment creator' do
    before :each do
      @comment.update(user: @user)
      sign_in @user
      visit post_path @post
      within('.post-comments') { click_link 'delete' }
    end

    scenario { should_not have_content @comment.content }
    scenario { should have_content 'Comment deleted' }
  end

  context 'as another user' do
    before :each do
      sign_in @user
      page.driver.submit :delete, comment_path(@comment), {}
    end

    scenario { should have_content 'not authorized' }

  end

  context 'without logging in' do
    before :each do
      page.driver.submit :delete, comment_path(@comment), {}
    end

    scenario { should have_content 'Please sign in' }
  end
end

# DELETE COMMENT - ANSWER
feature 'delete comment from an answer' do
  subject { page }

  before :each do
    @user = create(:user)
    @user2 = create(:user)
    @post = create(:post)
    @answer = create(:answer, post: @post)
    @comment = Comment.create(content: 'my comment', commentable: @answer, user: @user2)
  end

  scenario 'by visiting links' do
    @comment.update(user: @user)
    sign_in @user
    visit post_path @post
    within('.answer-comments') { click_link 'delete' }
    page.should have_title 'View post'
  end

  context 'as admin' do
    before :each do
      @user.update(admin: true)
      sign_in @user
      visit post_path @post
      within('.answer-comments') { click_link 'delete' }
    end

    scenario { should_not have_content @comment.content }
    scenario { should have_content 'Comment deleted' }
  end

  context 'as comment creator' do
    before :each do
      @comment.update(user: @user)
      sign_in @user
      visit post_path @post
      within('.answer-comments') { click_link 'delete' }
    end

    scenario { should_not have_content @comment.content }
    scenario { should have_content 'Comment deleted' }
  end

  context 'as another user' do
    before :each do
      sign_in @user
      page.driver.submit :delete, comment_path(@comment), {}
    end

    scenario { should have_content 'not authorized' }

  end

  context 'without logging in' do
    before :each do
      page.driver.submit :delete, comment_path(@comment), {}
    end

    scenario { should have_content 'Please sign in' }
  end
end

