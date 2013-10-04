class Answer < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  has_many :votes, as: :votable
  validates :content, presence: true, length: { maximum: 1000 }

  def points
    votes.count
  end

  def Answer.ranked
    Answer.all.sort { |x,y| y.points <=> x.points }
  end
end
