class ChangePostsAnsweredToBoolean < ActiveRecord::Migration
  def change
    remove_column :posts, :answered
    add_column :posts, :answered, :boolean, default: false
  end
end
