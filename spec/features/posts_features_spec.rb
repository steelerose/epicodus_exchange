require 'spec_helper'

# CREATE NEW POST
feature 'create new post' do
  subject { page }

  before :each do
    @user = create(:user)
  end

  scenario 'by visiting links' do
    sign_in @user
    visit root_path
    click_link 'Add post'
    page.should have_title 'Add post'
  end

  context 'logged in, with valid information' do
    before :each do
      sign_in @user
      visit new_post_path
      fill_in 'post_name', with: 'OMG HALP!'
      fill_in 'post_content', with: 'I think I broke something...'
      click_button 'Submit'
    end

    scenario { should have_content 'Post created' }
    scenario { should have_content 'OMG HALP!' }
    scenario { should have_content "#{@user.first_name} #{@user.last_name}" }
  end

  context 'logged in, with invalid information' do
    before :each do
      sign_in @user
      visit new_post_path
      click_button 'Submit'
    end

    scenario { should have_content('error') }
  end

  context 'not logged in' do
    before :each do
      visit root_path
    end

    scenario { should_not have_link 'New post' }

    scenario 'should not allow user to visit the new post form' do
      visit new_post_path
      page.should have_content 'Please sign in'
    end

    scenario 'should not allow user to create a post' do
      page.driver.submit :post, posts_path(post: { name: 'post name', content: 'post content' }), {}
      page.should have_content 'Please sign in'
    end
  end
end

# VIEW POST
feature 'view post' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    visit post_path @post
  end

  scenario 'by visiting links' do
    sign_in @user
    visit root_path
    click_link @post.name
    page.should have_title 'View post'
  end

  scenario { should have_content @post.name }
  scenario { should have_content @post.content }
  scenario { should have_link "#{@post.user.first_name} #{@post.user.last_name}" }

  context 'admin views post' do
    before :each do
      @user.update(admin: true)
      sign_in @user
      visit post_path @post
    end

    scenario { should have_button 'Issue resolved' }
    scenario { should have_link 'edit' }
    scenario { should have_link 'delete' }
    scenario { should have_link 'upvote' }
    scenario { should have_link 'comment' }
    scenario { should have_link 'answer' }

    scenario 'resolved post should not have Issue resolved button' do
      click_button 'Issue resolved'
      page.should_not have_button 'Issue resolved'
    end
  end

  context 'user views own post' do
    before :each do
      @post.update(user: @user)
      sign_in @user
      visit post_path @post
    end

    scenario { should have_button 'Issue resolved' }
    scenario { should have_link 'edit' }
    scenario { should_not have_link 'delete' }
    scenario { should_not have_link 'upvote' }
    scenario { should have_link 'comment' }
    scenario { should have_link 'answer' }

    scenario 'resolved post should not have Issue resolved button' do
      click_button 'Issue resolved'
      page.should_not have_button 'Issue resolved'
    end
  end

  context 'non-admin viewing another user\'s post' do
    before :each do
      sign_in @user
      visit post_path @post
    end

    scenario { should_not have_button 'Issue resolved' }
    scenario { should_not have_link 'edit' }
    scenario { should_not have_link 'delete' }
    scenario { should have_link 'upvote' }
    scenario { should have_link 'comment' }
    scenario { should have_link 'answer' }
  end

  context 'not logged in viewing post' do

    scenario { should_not have_button 'Issue resolved' }
    scenario { should_not have_link 'edit' }
    scenario { should_not have_link 'delete' }
    scenario { should_not have_link 'upvote' }
    scenario { should_not have_link 'comment' }
    scenario { should_not have_link 'answer' }
  end
end

# VIEW ALL POSTS
feature 'view all posts' do
  subject { page }

  before :each do
    @user = create(:user)
    @post1 = create(:post, created_at: (Time.now - 1.hour))
    @post2 = create(:post, created_at: (Time.now - 3.hours))
    @post3 = create(:post, created_at: (Time.now - 2.hours))
    visit posts_path
  end

  scenario 'by visiting links' do
    sign_in @user
    visit post_path @post1
    click_link 'Epicodus Exchange'
    page.should_not have_title '|'
  end

  scenario 'page should show all post names' do
    Post.all.each do |post|
      page.should have_link post.name
    end
  end

  scenario 'page should show all post creators' do
    Post.all.each do |post|
      page.should have_link "#{post.user.first_name} #{post.user.last_name}"
    end
  end

  scenario 'user can sort by post name or content' do

  end

  scenario 'user can select all unanswered posts' do

  end

  scenario 'user can select all answered posts' do

  end

  scenario 'user can view all posts' do

  end

end


describe PostsController do
  subject { page }

  before do
    @user = create(:user)
    sign_in(@user)
  end

  #mark post as answered (Issue resolved)
  #remove Issue resolved link after selecting
  #upvote post
  #edit post
  #delete post

  # EDIT PAGE
  describe 'Edit page' do
    before do
      @post = create(:post, user_id: @user.id)
      visit root_path
      click_link @post.name
      click_link 'edit'
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