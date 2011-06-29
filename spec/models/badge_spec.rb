require 'spec_helper'

describe Badge do
  describe "attributes" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:image)}
  end
  describe "associations" do
    it {should have_many(:badge_ownerships)}
    it {should have_many(:users).through(:badge_ownerships)}
  end
end
