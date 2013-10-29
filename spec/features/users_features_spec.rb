require 'spec_helper'

feature 'view user' do
  subject { page }

  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    @post = create(:post, user: @user1)
    @answer = create(:answer, user: @user1)
    visit user_path @user1
  end

  scenario { should have_content "#{@user1.first_name} #{@user1.last_name}" }
end

feature 'view all users' do
  before :each do
    @user1 = create(:user, first_name: 'Julie', last_name: 'Steele')
    @user2 = create(:user, first_name: 'Trevor', last_name: 'Steele')
    visit users_path
  end

  scenario 'by visiting links' do
    visit root_path
    click_link 'Roster'
    page.should have_title 'Roster'
  end

  scenario 'lists all users' do
    User.all.each do |user|
      page.should have_link "#{user.first_name} #{user.last_name}"
    end
  end
end

feature 'edit user profile' do
  subject { page }

  before :each do
    @user = create(:user)
    sign_in @user
    visit user_path @user
    click_link 'Settings'
  end

  # scenario 'with invalid information' do
  #   fill_in 'user_first_name', with: ''
  #   fill_in 'user_current_password', with: @user.password
  #   click_button 'Update'
  #   page.should have_content 'error'
  # end

  scenario 'with wrong password' do
    fill_in 'user_first_name', with: 'Newname'
    fill_in 'user_current_password', with: 'notmypassword'
    click_button 'Update'
    page.should have_content 'error'
  end

  # scenario 'with valid information' do
  #   fill_in 'user_first_name', with: 'Newname'
  #   fill_in 'user_current_password', with: @user.password
  #   click_button 'Update'
  #   page.should have_content 'Newname'
  # end
end

feature 'make admin' do
  context 'as admin' do
    
  end

  context 'as correct user' do
    
  end

  context 'as another user' do
    
  end

  context 'without logging in`' do
    
  end
end

feature 'delete user' do
  subject { page }

  before :each do
    @user = create(:user)
    sign_in @user
    visit user_path @user
    click_link 'Settings'
  end
  
  context 'as admin' do
    # should not be able to delete self unless there is another admin
    # link should be on user profile page
  end

  context 'as correct user' do
    
  end
end