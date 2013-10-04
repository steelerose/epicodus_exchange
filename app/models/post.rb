class Post < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :votes, as: :votable
  validates :content, presence: true, length: { maximum: 1000 }
  validates :name, presence: true, length: { maximum: 100 }

  def Post.unanswered
    Post.where(answered: false).sort { |x,y| y.points <=> x.points }
  end

  def Post.answered
    Post.where(answered: true).sort { |x,y| y.points <=> x.points }
  end

  def points
    votes.count + time_points
  end

  def Post.by_points
    Post.all.sort { |x,y| y.points <=> x.points }
  end

private

  def time_points
    minutes_since = (Time.now.strftime('%s').to_i - created_at.strftime('%s').to_i) / 60
    minutes_since < 30 ? 60 - (minutes_since * 2) : 0 
  end
end