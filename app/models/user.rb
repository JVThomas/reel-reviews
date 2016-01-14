class User < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :movies, through: :reviews
  has_secure_password

  def slug
    self.username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    self.all.find{|item| item.slug == slug}
  end
end