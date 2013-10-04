class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  validates :user_id, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
end
