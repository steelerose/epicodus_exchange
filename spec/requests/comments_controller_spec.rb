require 'spec_helper'

describe CommentsController do
  subject { page }

  # NEW PAGE
  describe 'New page' do
    before do
      @post = create(:post)
      visit post_path(@post)
      click_link 'Answer post'
      fill_in 'Answer:', with: 'Help is on the way!'
      click_button 'Submit'
      click_link 'Reply'
    end

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

      it 'should display a confirmation message' do
        click_button 'Submit'
        expect(page).to have_content('Comment added')
      end

      it 'should add an answer to the database' do
        expect { click_button 'Submit' }.to change(Comment, :count).by(1)
      end
    end
  end

  # EDIT PAGE
  describe 'Edit page' do
    before do
      @post = create(:post)
      visit post_path(@post)
      click_link 'Answer post'
      fill_in 'Answer:', with: 'Help is on the way!'
      click_button 'Submit'
      click_link 'Reply'
      fill_in 'Comment:', with: 'When? I\'m desperate!'
      click_button 'Submit'
      click_link 'edit comment'
    end

    it { should have_title('Edit comment') }
    it { should have_content(@post.name) }

    describe 'with invalid information' do
      before do
        fill_in 'Comment:', with: ''
        click_button 'Save changes'
      end

      it { should have_title('Edit comment') }
      it { should have_content('error') }

      it 'should not update the post in the database' do
        @post.answers.first.comments.first.reload
        @post.answers.first.comments.first.content.should_not eq ''
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Comment:', with: '...or not'
        click_button 'Save changes'
      end

      it { should have_title('View post') }
      it { should have_content(@post.name) }

      it 'should update the post in the database' do
        @post.answers.first.comments.first.reload
        @post.answers.first.comments.first.content.should eq '...or not'
      end
    end
  end
end