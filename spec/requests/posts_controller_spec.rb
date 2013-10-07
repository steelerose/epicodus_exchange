require 'spec_helper'

describe PostsController do
  subject { page }

  before do
    @user = create(:user)
    visit '/users/sign_in'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
  end

  # INDEX / ROOT PAGE
  describe 'Index page / root path' do
    before do
      3.times { create(:post) }
      visit root_path
    end

    it 'should display all posts' do
      Post.all.each { |post| expect(page).to have_content post.name }
    end
  end

  # NEW PAGE
  describe 'New page' do
    before do
      visit root_path
      #log in
      click_link 'Add post'
    end

    describe 'with invalid information' do
      it 'should not redirect to home' do
        click_button 'Submit'
        expect(page).to have_title('Add post')
      end

      it 'should display errors' do
        click_button 'Submit'
        expect(page).to have_content('error')
      end

      it 'should not add a post to the database' do
        expect { click_button 'Submit' }.not_to change(Post, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Post title:', with: 'OMG HALP!'
        fill_in 'Post content:', with: 'Please fix me... I think I broke something'
      end

      it 'should redirect to home' do
        click_button 'Submit'
        expect(page).not_to have_title('|')
      end

      it 'should display a confirmation message' do
        click_button 'Submit'
        expect(page).to have_content('Post created')
      end

      it 'should add a post to the database' do
        expect { click_button 'Submit' }.to change(Post, :count).by(1)
      end

      it 'should have a user' do
        click_button 'Submit'
        Post.all.first.user.should_not be_nil
      end
    end
  end

  # SHOW PAGE
  describe 'Show page' do
    before do
      @post = create(:post, user_id: @user.id)
      @post.answers.create(content: 'I can help!', user_id: @user.id)
      @post.answers.first.comments.create(content: 'No you can\'t', user_id: @user.id)
      visit root_path
      click_link @post.name
    end

    it { should have_title('View post') }
    it { should have_content(@post.name) }

    it 'should allow you to delete a post' do
      expect { click_link 'delete post' }.to change(Post, :count).by(-1)
      expect(page).not_to have_title('|')
    end

    it 'should allow you to mark a post as \'answered\'' do
      click_button 'Issue resolved'
      @post.reload
      @post.answered?.should be_true
    end

    it 'should allow you to delete an answer' do
      expect { click_link 'delete answer' }.to change(Answer, :count).by(-1)
    end

    it 'should allow you to upvote an answer' do
      find(:xpath, "(//a[text()='upvote'])[2]").click
      @post.answers.first.reload
      @post.answers.first.votes.count.should eq 1
    end

    it 'should allow you to delete a comment' do
      expect { click_link 'delete comment' }.to change(Comment, :count).by(-1)
    end
  end

  # EDIT PAGE
  describe 'Edit page' do
    before do
      @post = create(:post)
      visit root_path
      click_link @post.name
      click_link 'edit post'
    end

    it { should have_title('Edit post') }
    it { should have_content(@post.name) }

    describe 'with invalid information' do
      before do
        fill_in 'Post title:', with: ''
        click_button 'Save changes'
      end

      it { should have_title('Edit post') }
      it { should have_content('error') }

      it 'should not update the post in the database' do
        @post.reload
        @post.name.should_not eq ''
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Post title:', with: 'new problem'
        click_button 'Save changes'
      end

      it { should_not have_title('|') }
      it { should have_content('Edit confirmed') }

      it 'should update the post in the database' do
        @post.reload
        @post.name.should eq 'new problem'
      end
    end
  end
end