# Epicodus Exchange

Q&A forum for Epicodus students

Created by [Julie Steele](https://github.com/steelerose).

------------

To run:

In the terminal
- 'bundle install' to install the necessary gems
- 'rake db:create' to create your database
- 'rake db:schema:load' to load all migrations
- 'rails s' to start your server.

In your browser
- visit 'localhost:3000'

------------


TO ADD
  ADMIN
  - can create announcement (type of post)
  - profile page has 'Make admin' button
  - profile page has 'Delete account' button
  - can mark answer as correct
  POST INDEX
  - can show only answered/unanswered/all
  USERS TABLE
  - add user types: prospective student, class of __ or student/alum, etc

TO FIX
  ANSWER
  - new/edit features should be AJAX
  USER
  - validate fields when updating (name can't be blank, etc)
  - successful edit redirects to profile page