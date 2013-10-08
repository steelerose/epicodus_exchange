class ChangeCommentContentToStringFromText < ActiveRecord::Migration
  def change
    remove_column :comments, :content

    add_column :comments, :content, :string
  end
end
