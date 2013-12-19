require 'spec_helper'

describe "hoges/index" do
  before(:each) do
    assign(:hoges, [
      stub_model(Hoge,
        :titile => "Titile",
        :comment => ""
      ),
      stub_model(Hoge,
        :titile => "Titile",
        :comment => ""
      )
    ])
  end

  it "renders a list of hoges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Titile".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
