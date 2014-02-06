require 'spec_helper'

describe "Breweries page" do
  it "should not have any before been created" do
    visit breweries_path
    expect(page).to have_content 'Listing breweries'
    expect(page).to have_content 'Number of breweries: 0'

  end

  describe "when breweries exists" do
    before :each do
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      @breweries.each do |brewery_name|
        FactoryGirl.create(:brewery, name: brewery_name, year: year += 1)
      end

      visit breweries_path
    end

    it "lists the breweries and their total number" do
      expect(page).to have_content "Number of breweries: #{@breweries.count}"
      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it "allows user to navigate to page of a Brewery" do
      click_link "Koff"

      expect(page).to have_content "Koff"
      expect(page).to have_content "Established in 1897"
    end

  end

  describe "creating new beer" do
    it "should add new beer with valid data" do
      FactoryGirl.create :user
      sign_in(username:"Pekka", password:"Foobar1")
      brewery = FactoryGirl.create(:brewery)
      visit new_beer_path

      fill_in('beer_name', with:'Test')

      select('Lager', from: 'beer_style')
      select(brewery.name, from: 'beer_brewery_id')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)
    end

    it "should not add new beer with invalid data" do
      FactoryGirl.create :user
      sign_in(username:"Pekka", password:"Foobar1")
      brewery = FactoryGirl.create(:brewery)
      visit new_beer_path

      select('Lager', from: 'beer_style')
      select(brewery.name, from: 'beer_brewery_id')

      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(0)

      expect(current_path).to eq(beers_path)
      expect(page).to have_content "Name can't be blank"
    end

  end
end