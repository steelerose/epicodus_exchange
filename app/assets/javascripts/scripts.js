$(function() {
  $('.new-comment').click(function() {
    $(this).next('ul div.new-comment-form').show();
    return false;
  });
  return false;
});