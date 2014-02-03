class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
            length: { minimum: 3, maximum: 15 }

  validates :password, length: { minimum: 4 },
            format: { with: /.*(\d.*[A-Z]|[A-Z].*\d).*/,
                      message: "should contain a uppercase letter and a number" }

  has_many :ratings   # käyttäjällä on monta ratingia

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    style_ratings = ratings.group_by { |rating| rating.beer.style }
    average_rating_for_param style_ratings
  end

  def average_rating_for_param param_ratings
    highest_avg = 0
    highest_avg_name = ""

    param_ratings.each do | item |
      sum = item[1].inject(0) { | sum, rating | sum + rating.score }

      count = item[1].inject(0) { | count | count + 1 }

      if ((sum / count) > highest_avg)
        highest_avg = (sum / count)
        highest_avg_name = item[0]
      end
    end

    highest_avg_name
  end

  def favorite_brewery
    return nil if ratings.empty?
    brewery_ratings = ratings.group_by { |rating| rating.beer.brewery }
    average_rating_for_param brewery_ratings
  end

end
