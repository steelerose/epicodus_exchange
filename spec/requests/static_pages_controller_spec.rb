require 'spec_helper'

describe StaticPagesController do
  subject { page }

  it 'should have functional links' do
    visit root_path
    click_link 'Epicodus Exchange'
    expect(page).to have_title('Epicodus Exchange')
  end

  # it 'should link back to the creator\'s website' do
  #   visit root_path
  #   click_link 'Julie Steele'
  #   current_url.should eq 'http://juliesteele.site44.com/'
  # end
end