require 'spec_helper'

describe ExternalTransaction do
  it { should belong_to   :external_account }
  it { should belong_to   :person }
  it { should belong_to   :funds_transfer }
end
