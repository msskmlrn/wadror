require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    @user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "favorites" do
    it "do not exists when no ratings have been given" do
      sign_in(username:"Pekka", password:"Foobar1")
      expect(page).to have_content 'has not yet made ratings'
      expect(page).not_to have_content("Favorite style")
      expect(page).not_to have_content("Favorite brewery")
    end

    it "exist when there is at least one rating" do
      brewery = FactoryGirl.create :brewery, name: "Koff"
      beer = FactoryGirl.create :beer, name:"iso 3", brewery:brewery
      rating = FactoryGirl.create :rating, beer: beer, score: 10, user: @user

      visit user_path(@user)
      expect(page).to have_content("Favorite style")
      expect(page).to have_content("Favorite brewery")
    end
  end
end