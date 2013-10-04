class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.binary :answered, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
