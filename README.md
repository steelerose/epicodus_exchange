# Epicodus Exchange: Q&A forum for Epicodus students

Created by [Julie Steele](http://juliesteele.site44.com/).


FIX:
- Update and uncomment final line in config/environments/production.rb (host => 'localhost:3000')
- 'Delete Post' button shows confirmation popup twice
- Navbar dropdown menus
- New/edit comment is on show post page, not on new page
- Mark post as answered stays on show post page
- Misc. devise pages (remember me, forgot password, email new password, etc)
- CanCan tests for create, update, destroy

ADD:
- Users index page
  - auto sort by rank
  - searchable by name (first, last, or both)
  - searchable by github
  - within results, can show only one type (student, alumni, etc)
  - within results, can show only one class (ex: Fall 2013)
- Users page
  - admin can make a user a moderator or admin
  - show rank
  - show saved/starred questions
- Posts page
  - ability to star/save question
  - admin can mark answer as correct
  - show all comments for post
- New post page
  - admin can mark a new post as question or announcement
- Posts index page
  - shows announcements above questions
  - change time-points algorythm
  - ability to search by combination of post name, post content, answer content
  - admin can view all resolved questions
  - within results, can show all results or only answered posts
Admin abilities
  - admin can manage (edit or delete) posts, answers, comments, and users
  - admin can mark a post as answered
Footer
  - created by, copyright, contact, etc
  - http://stackoverflow.com/questions/13178801/creating-footer-using-zurb-foundation-css-framework
Static Pages
  - Link to Epicodus main page
  - Contact
  - Help
Comments
  - make Comment model 'commentable' - attach to Post & Answer
