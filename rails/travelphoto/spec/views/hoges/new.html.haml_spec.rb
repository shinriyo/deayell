require 'spec_helper'

describe "hoges/new" do
  before(:each) do
    assign(:hoge, stub_model(Hoge,
      :titile => "MyString",
      :comment => ""
    ).as_new_record)
  end

  it "renders new hoge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hoges_path, "post" do
      assert_select "input#hoge_titile[name=?]", "hoge[titile]"
      assert_select "input#hoge_comment[name=?]", "hoge[comment]"
    end
  end
end
