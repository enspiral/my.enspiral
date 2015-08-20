require 'spec_helper'

describe ExternalAccount do
  it { should belong_to :company }
  it { should have_many :external_transactions }
end
