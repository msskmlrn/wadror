require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with too short a password" do
    let(:user){ User.create username:"Pekka", password:"Ab1", password_confirmation:"Ab1" }

    it "is not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "with password that consists only of letters" do
    let(:user){ User.create username:"Pekka", password:"abcddddddd", password_confirmation:"abcddddddd" }

    it "is not saved" do
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  #Tee seuraavaksi TDD-tyylillä User-olioille metodi favorite_style,
  # joka palauttaa tyylin, jonka oluet ovat saaneet käyttäjältä keskimäärin
  # korkeimman reittauksen. Lisää käyttäjän sivulle tieto käyttäjän mielityylistä.

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has a method for determining the favorite style" do
      user.should respond_to :favorite_style
    end

    it "without beers does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    #it "is the only style if only one style" do
    #  beer = create_beer_with_rating(10, user)

    #  expect(user.favorite_style).to eq(beer.style)
    #end

    #it "is the one with the highest average rating if several rated" do
    #  create_beers_with_ratings_and_style(10, 20, 15, 7, "Lager", user)
    #  create_beers_with_ratings_and_style(11, 21, 16, 8, "Porter", user)
    #  best = create_beers_with_ratings_and_style(50, "Lager", user)

    #  expect(user.favorite_style).to eq(best.style)
    #end

  end

end # describe User

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_rating_and_style(score, style, user)
  beer = FactoryGirl.create(:beer, style:style)
  FactoryGirl.create(:rating, score: score, beer: beer, user: user)
  beer
end

def create_beers_with_ratings_and_style(*scores, style, user)
  scores.each do |score|
    create_beer_with_rating_and_style(score, style, user)
  end
end
