class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :user_id, presence: true, uniqueness: { scope: [:votable_id, :votable_type] }
 #  before_create :verify_honest_vote

 # private

 # 	def verify_honest_vote
 # 		binding.pry
 # 		self.user != self.votable.user
 # 	end
end
