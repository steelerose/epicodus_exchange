class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :answers
  has_many :votes, as: :votable
  validates :content, presence: true, length: { maximum: 5000 }
  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  default_scope { order('created_at DESC') }

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

  def Post.search(keyword)
    keywords = keyword.to_s.downcase.strip.split.uniq
    results = []
    keywords.each { |keyword| results.concat(Post.basic_search(keyword)) }
    results.uniq
  end

private

  def time_points
    minutes_since = (Time.now.strftime('%s').to_i - created_at.strftime('%s').to_i) / 60
    minutes_since < 30 ? 60 - (minutes_since * 2) : 0 
  end
end
