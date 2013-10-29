require 'spec_helper'

feature 'header' do
  subject { page }

  context 'before logging in' do
    before { visit root_path }
    
    scenario { should have_link 'Sign in' }
    scenario { should have_link 'Sign up' }
    scenario { should_not have_link 'Sign out' }
    scenario { should_not have_link 'Profile' }
    scenario { should_not have_link 'Settings' }
  end

  context 'before logging in' do
    before :each do
      user = create(:user)
      sign_in user
      visit root_path
    end

    scenario { should_not have_link 'Sign in' }
    scenario { should_not have_link 'Sign up' }
    scenario { should have_link 'Sign out' }
    scenario { should have_link 'Profile' }
    scenario { should have_link 'Settings' }
  end
end