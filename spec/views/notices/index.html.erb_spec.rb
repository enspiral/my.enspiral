require 'spec_helper'

describe "notices/index.html.erb" do
  before(:each) do
    person = Person.make
    person.save!
    notice = Notice.make :person => person
    notice.save!
    assign(:notices, Notice.page(params[:page]))
  end

  it "renders a list of notices" do
    render
  end
end
