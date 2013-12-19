require 'spec_helper'

describe "hoges/show" do
  before(:each) do
    @hoge = assign(:hoge, stub_model(Hoge,
      :titile => "Titile",
      :comment => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Titile/)
    rendered.should match(//)
  end
end
