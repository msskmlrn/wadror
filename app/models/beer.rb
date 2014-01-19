class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy

  def average_rating
    ratings.average(:score)
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end