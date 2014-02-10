require 'spec_helper'

describe Beer do
  it "is saved with a name and a style" do
    beer = FactoryGirl.create :beer

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    style = FactoryGirl.create :style
    beer = Beer.create style: style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end
