require 'spec_helper'

# VIEW USER
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

  context 'as admin' do
    before :each do
      @user2.update(admin: true)
      sign_in @user2
      visit user_path @user1
    end

    scenario { should have_button 'Make admin' }
    scenario { should have_button 'Delete account' }
  end

  context 'as admin, viewing admin' do
    before :each do
      @user2.update(admin: true)
      @user1.update(admin: true)
      sign_in @user2
      visit user_path @user1
    end

    scenario { should_not have_button 'Make admin' }
  end

  context 'as non-admin' do
    before :each do
      sign_in @user1
      visit user_path @user1
    end

    scenario { should_not have_button 'Make admin' }
    scenario { should_not have_button 'Delete account' }
  end
end

# VIEW ALL USERS
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

# EDIT USER
# feature 'edit user profile' do
#   subject { page }

#   before :each do
#     @user = create(:user)
#     sign_in @user
#     visit user_path @user
#     click_link 'Settings'
#   end

#   scenario 'with invalid information' do
#     fill_in 'user_first_name', with: ''
#     fill_in 'user_current_password', with: @user.password
#     click_button 'Update'
#     page.should have_content 'error'
#   end

#   scenario 'with valid information' do
#     fill_in 'user_first_name', with: 'Newname'
#     fill_in 'user_current_password', with: @user.password
#     click_button 'Update'
#     page.should have_content 'Newname'
#   end
# end

# MAKE ADMIN
feature 'make admin' do
  subject { page }

  before :each do
    @user = create(:user)
    @user2 = create(:user)
    @user2.update(admin: true)
  end

  scenario 'as admin' do
    sign_in @user2
    visit user_path @user
    visit user_path @user
    click_button 'Make admin'
    page.should have_content 'Admin powers granted!'
  end

  scenario 'as non-admin' do
    sign_in @user
    visit user_path @user
    page.driver.submit :post, admins_path(user_id: @user.id, user: { admin: true }), {}
    page.should have_content 'not authorized'
  end
end

# DELETE USER
feature 'delete user' do
  subject { page }

  before :each do
    @user = create(:user)
  end

  context 'as admin' do
    before :each do
      @user2 = create(:user)
      @user2.update(admin: true)
      sign_in @user2
    end

    scenario 'deleting other user' do
      visit user_path @user
      click_button 'Delete account'
      page.should have_content 'Account deleted'
    end

    scenario 'deleting self (other admins exist)' do
      @user.update(admin: true)
      visit user_path @user2
      click_button 'Delete account'
      page.should have_content 'Your account has been deleted'
    end

    scenario 'deleting self (no other admins exist)' do
      visit user_path @user2
      click_button 'Delete account'
      page.should have_content 'Please assign a new admin before deleting your account'
    end
  end

  context 'as non-admin' do
    before :each do
      sign_in @user
      visit user_path @user
    end

    scenario 'by directly destroying' do
      page.driver.submit :delete, user_path(@user), {}
      page.should have_content 'not authorized'
    end
  end
end