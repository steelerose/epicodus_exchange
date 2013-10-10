require 'spec_helper'

describe SessionsController do
  subject { page }

  before do
    @post = create(:post)
    @answer = create(:answer, post: @post)
    @comment = create(:comment, commentable: @answer)
    visit root_path
  end

  describe 'Not signed in' do
    it { should_not have_content "Add post" }
    it { should_not have_content "Profile" }
    it { should_not have_content "Settings" }
    it { should_not have_content "Sign out" }

    describe 'post should not have links to manage post, answers, or comments' do
      before { visit post_path(@post) }

      it { should_not have_content 'edit' }
      it { should_not have_content 'delete' }
      it { should_not have_button 'Issue resolved' }
    end

    it 'redirects to the Sign In page from forbidden pages' do
      visit post_path(@post)
      find(:xpath, "(//a[text()='upvote'])[1]").click
      expect(page).to have_title 'Sign in'
      visit post_path(@post)
      click_link 'answer'
      expect(page).to have_title 'Sign in'
      visit post_path(@post)
      find(:xpath, "(//a[text()='upvote'])[2]").click
      expect(page).to have_title 'Sign in'
      visit post_path(@post)
      find(:xpath, "(//a[text()='comment'])[1]").click
      expect(page).to have_title 'Sign in'
      #add comment to post
    end

    it 'prevents user from manually visiting forbidden paths' do
      visit '/posts/new'
      expect(page).to have_title 'Sign in'
      # posts#create
      visit "/posts/#{@post.id}/edit"
      expect(page).to have_title 'Sign in'
      # posts#update
      # posts#destroy
      visit "/answers/new?post=#{@post.id}"
      expect(page).to have_title 'Sign in'
      # answers#create
      visit "/answers/#{@answer.id}/edit"
      expect(page).to have_title 'Sign in'
      # answers#update
      # answers#destroy
      visit "/comments/new?answer=#{@answer.id}"
      expect(page).to have_title 'Sign in'
      # comments#create
      # comments#destroy
      # votes#create
    end
  end

  describe 'Signed in' do
    before do
      @user = create(:user)
      visit '/users/sign_in'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Sign in'
    end

    it { should_not have_content "Sign up" }
    it { should_not have_content "Sign in" }

    it 'prevents user from manually managing other user\'s posts, answers, or comments' do
      visit "/posts/#{@post.id}/edit"
      expect(page).to have_content 'Salutations!'
      # posts#update
      visit "/answers/#{@answer.id}/edit"
      expect(page).to have_content 'Salutations!'
      # answers#update
    end

    describe 'other user\'s posts should not have links to manage post, answers, or comments' do
      before { visit post_path(@post) }

      it { should_not have_content 'edit post' }
      it { should_not have_content 'delete post' }
      it { should_not have_button 'Issue resolved' }
      it { should_not have_content 'edit answer' }
      it { should_not have_content 'delete answer' }
      it { should_not have_content 'delete comment' }
    end
  end

end