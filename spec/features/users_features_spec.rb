require 'spec_helper'

feature 'view user' do
  #should show name
  #should link to github
  #should link to website
  #should show points
  #should show rank
  #should show all posts

  context 'as admin' do
    #should be able to edit
    #should be able to delete
  end

  context 'viewing own page' do
    #should be able to edit
    #should be able to delete
  end

  context 'viewing another user\'s page' do
    #should not be able to edit
    #should not be able to delete
  end

  context 'without logging in`' do
    #should not be able to edit
    #should not be able to delete
  end
end

feature 'view all users' do
  #should be able to search by name or github
  #should be able to view current students, etc
end

