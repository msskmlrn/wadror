require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "on the beer page" do

    it "shows no ratings when there are none" do
      visit beer_path(beer2)
      expect(page).to have_content 'beer has not yet been rated!'
    end

    it "shows rating when there is one" do
      beer1.ratings << FactoryGirl.create(:rating)

      visit beer_path(beer1)
      expect(page).to have_content "has been rated 1 times"
      expect(page).to have_content "average score 10.0"
    end

    it "shows rating when there are some" do
      beer1.ratings << FactoryGirl.create(:rating)
      beer1.ratings << FactoryGirl.create(:rating2)

      visit beer_path(beer1)
      expect(page).to have_content "has been rated 2 times"
      expect(page).to have_content "average score 15.0"
    end

  end


  describe "on the user page" do

    it "shows no ratings when there are none" do
      visit user_path(user)
      expect(page).to have_content "#{user.username}"
      expect(page).to have_content 'has not yet made ratings'
    end

    it "shows rating when there is one" do
      user.ratings << FactoryGirl.create(:rating, beer: beer1)

      visit user_path(user)
      expect(page).to have_content "#{user.username}"
      expect(page).to have_content 'has made 1 rating'
    end

    it "shows rating when there are some" do
      user.ratings << FactoryGirl.create(:rating, beer: beer1)
      user.ratings << FactoryGirl.create(:rating, beer: beer2)

      visit user_path(user)
      expect(page).to have_content "#{user.username}"
      expect(page).to have_content 'has made 2 ratings'
    end

    it "deleting a rating removes it from the database" do
      user.ratings << FactoryGirl.create(:rating, beer: beer1)
      visit user_path(user)

      expect{
        click_link('delete')
        }.to change{user.ratings.count}.by(-1)
    end

  end
end