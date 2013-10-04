class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :content

      t.timestamps
    end
  end
end
