# Epicodus Exchange: Q&A forum for Epicodus students

Created by [Julie Steele](http://juliesteele.site44.com/).


FIX:
- Update and uncomment final line in config/environments/production.rb (host => 'localhost:3000')
- Misc. devise pages (remember me, forgot password, email new password, etc)
- CanCan tests for create, update, destroy
- First comment doesn't automatically show
- Only open reply box for ONE comment
- Add tests for new comments AJAX functionality

ADD:
- Everywhere
  - Prettify

- Posts Index Page (Home)
  - can choose to view all questions, resolved questions, or unresolved questions
- Posts Show Page (one post)
  - add comments for posts (link, display, etc)
  - add counter to comments to show how many characters are left

- Users Index Page (all users)
  - searchable by name and github

- Static Pages
  - Navbar
    - remove dropdown menus
    - add dividers




AFTER ADMIN:
- Posts Index Page (Home)
  - search all questions does not search announcements
  - show announcements above questions
  - rank announcements by date only
  - fix time-points algorythm
- Posts Show Page (one post)
  - ability to star/save question
  - admin can mark answer as correct
  - allow paragraph breaks in posts and answers
  - allow code/special font in posts and answers
  - use AJAX for marking post as answered (should stay on page and remove button)
- New Post Page
  - Admin can mark new post as question or announcement

- Users Index Page (all users)
  - can show only one type (student, alumni, etc)
  - can show only one class (Fall 2013)
- Users Page (one user)
  - admin can make user moderator or admin
  - show saved/starred questions

- Admin Abilities
  - admin can manage *everything*
  - admin can mark a post as answered
  - only admin can delete a post

- Footer
  - created by, copywright, contact, etc
  - http://stackoverflow.com/questions/13178801/creating-footer-using-zurb-foundation-css-framework

- Navbar
  - add dropdown menus

- Static Pages
  - Link to Epicodus main page
  - Contact
  - Help
