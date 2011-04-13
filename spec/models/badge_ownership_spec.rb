require 'spec_helper'

describe BadgeOwnership do
  describe "attributes" do
    it {should belong_to(:user)}
    it {should belong_to(:badge)}
    it {should belong_to(:person)}
    it {should validate_presence_of(:reason)}
    it {should validate_presence_of(:user)}
    it {should validate_presence_of(:person)}

  end
end
