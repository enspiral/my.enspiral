require 'spec_helper'

describe Admin::ProjectsHelper do

  before :each do 
    stub!(:sort_column).and_return('name')
    stub!(:sort_direction).and_return('asc')
  end

  it 'returns a link from the sortable function' do
  end
end
