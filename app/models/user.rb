class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :answers
  has_many :comments
  has_many :votes
  before_save :standardize_url

  def rank
    User.by_rank.index { |user| user.karma == self.karma } + 1
  end

  def User.by_rank
    User.all.sort { |x,y| y.karma <=> x.karma }
  end

  def update_karma
    current_karma = self.answers.reduce(0) { |total, answer| total + answer.votes.count }
    self.update(karma: current_karma)
    current_karma
  end

  def User.search(keyword)
    keywords = keyword.to_s.downcase.strip.split.uniq
    results = []
    keywords.each { |keyword| results.concat(User.basic_search(keyword)) }
    results.uniq
  end

private

  def standardize_url
    if !self.website.empty? && !self.website.match(/\Ahttps?:\/\//i)
      self.website = "http://#{self.website}"
    end
  end
end
