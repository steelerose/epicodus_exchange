require 'spec_helper'

# CREATE NEW ANSWER
feature 'create new answer' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    visit post_path @post
  end

  scenario 'by visiting links' do
    sign_in @user
    visit post_path @post
    click_link 'answer'
    page.should have_title 'Answer'
  end

  context 'logged in, with valid information' do
    before :each do
      sign_in @user
      visit post_path @post
      click_link 'answer'
      fill_in 'answer_content', with: 'Here\'s an awesome solution'
      click_button 'Submit'
    end

    scenario { should have_content 'Answer added' }
    scenario { should have_content 'Here\'s an awesome solution' }
    scenario { should have_content "#{@user.first_name} #{@user.last_name}" }
  end

  context 'logged in, with invalid information' do
    before :each do
      sign_in @user
      visit post_path @post
      click_link 'answer'
      click_button 'Submit'
    end

    scenario { should have_content('error') }
  end

  context 'not logged in' do
    scenario 'should not allow user to visit the new answer form' do
      visit new_answer_path(post: @post)
      page.should have_content 'Please sign in'
    end

    scenario 'should not allow user to create a answer' do
      page.driver.submit :post, answers_path(answer: { content: 'answer content', post_id: @post.id }), {}
      page.should have_content 'Please sign in'
    end
  end
end

# EDIT ANSWER
feature 'edit answer' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    @answer = create(:answer, post: @post)
    visit post_path @post
  end

  scenario 'by visiting links' do
    @answer.update(user: @user)
    sign_in @user
    visit post_path @post
    within('.answer-options') { click_link 'edit' }
    page.should have_title 'Edit answer'
  end

  context 'as admin' do
    before :each do
      @user.update(admin: true)
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'edit' }
      fill_in 'answer_content', with: 'A better answer would be...'
      click_button 'Save changes'
    end

    scenario { should have_content 'A better answer would be...' }
    scenario { should have_content 'Edit confirmed' }
  end

  context 'as answer creator, with valid content' do
    before :each do
      @answer.update(user: @user)
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'edit' }
      fill_in 'answer_content', with: 'A better answer would be...'
      click_button 'Save changes'
    end

    scenario { should have_content 'A better answer would be...' }
    scenario { should have_content 'Edit confirmed' }
  end

  context 'as answer creator, with invalid content' do
    before :each do
      @answer.update(user: @user)
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'edit' }
      fill_in 'answer_content', with: ''
      click_button 'Save changes'
    end

    scenario { should have_content 'error' }
  end

  context 'as another user' do
    before :each do
      sign_in @user
      page.driver.submit :patch, answer_path(id: @post.id, answer: { content: 'answer-content', answer_id: @answer.id }), {}
    end

    scenario { should have_content 'not authorized' }

  end

  context 'without logging in' do
    scenario 'directly visiting edit answer path' do
      visit edit_answer_path @answer
      should have_content 'Please sign in'
    end

    scenario 'directly updating answer' do
      page.driver.submit :patch, answer_path(id: @post.id, answer: { content: 'answer-content', answer_id: @answer.id }), {}
      page.should have_content 'Please sign in'
    end
  end
end

# DELETE ANSWER
feature 'delete answer' do
  subject { page }

  before :each do
    @user = create(:user)
    @post = create(:post)
    @answer = create(:answer, post: @post)
  end

  scenario 'by visiting links' do
    @answer.update(user: @user)
    sign_in @user
    visit post_path @post
    within('.answer-options') { click_link 'delete' }
    page.should have_title 'View post'
  end

  context 'as admin' do
    before :each do
      @user.update(admin: true)
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'delete' }
    end

    scenario { should_not have_content @answer.content }
    scenario { should have_content 'Answer deleted' }
  end

  context 'as answer creator' do
    before :each do
      @answer.update(user: @user)
      sign_in @user
      visit post_path @post
      within('.answer-options') { click_link 'delete' }
    end

    scenario { should_not have_content @answer.content }
    scenario { should have_content 'Answer deleted' }
  end

  context 'as another user' do
    before :each do
      sign_in @user
      page.driver.submit :delete, answer_path(id: @post.id, answer_id: @answer.id), {}
    end

    scenario { should have_content 'not authorized' }

  end

  context 'without logging in' do
    before :each do
      page.driver.submit :delete, answer_path(id: @post.id, answer_id: @answer.id), {}
    end

    scenario { should have_content 'Please sign in' }
  end
end




