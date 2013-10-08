class ChangePostAnswerCommentContentFromStringToText < ActiveRecord::Migration
  def change
    remove_column :posts, :content
    remove_column :answers, :content
    remove_column :comments, :content

    add_column :posts, :content, :text
    add_column :answers, :content, :text
    add_column :comments, :content, :text
  end
end
