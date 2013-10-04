class Comment < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user
  validates :content, presence: true, length: { maximum: 500 }
  validates :user_id, presence: true
  default_scope { order('created_at ASC') }
end
