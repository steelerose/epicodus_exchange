require 'spec_helper'

describe CommentsController do
  subject { page }

  before do
    @user = create(:user)
    visit '/users/sign_in'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
    @post = create(:post, user_id: @user.id)
    visit post_path(@post)
    click_link 'answer'
    fill_in 'Answer:', with: 'Help is on the way!'
    click_button 'Submit'
    find(:xpath, "(//a[text()='comment'])[2]").click
  end

  # NEW PAGE
  describe 'New page' do
    describe 'with invalid information' do
      it 'should not redirect to the post\'s main page' do
        click_button 'Submit'
        expect(page).to have_title('Comment')
      end

      it 'should display errors' do
        click_button 'Submit'
        expect(page).to have_content('error')
      end

      it 'should not add a comment to the database' do
        expect { click_button 'Submit' }.not_to change(Comment, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Comment:', with: 'When? I\'m desperate!'
      end

      it 'should redirect to the post\'s main page' do
        click_button 'Submit'
        expect(page).to have_title('View post')
        expect(page).to have_content(@post.name)
      end

      it 'should add an answer to the database' do
        expect { click_button 'Submit' }.to change(Comment, :count).by(1)
      end

      it 'should have a user' do
        click_button 'Submit'
        @post.answers.first.comments.first.user.should_not be_nil
      end
    end
  end
end