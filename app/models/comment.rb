class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :content, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  default_scope { order('created_at DESC') }
end
