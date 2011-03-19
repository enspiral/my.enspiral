require 'spec_helper'

describe BadgeOwnership do
  describe "attributes" do
    it {should belong_to(:user)}
    it {should belong_to(:badge)}
    it {should validate_presence_of(:reason)}

  end
end
