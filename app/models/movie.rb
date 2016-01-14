class Movie < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews

  def slug
    self.name.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    self.all.find{|item| item.slug == slug}
  end

end