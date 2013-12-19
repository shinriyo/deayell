require 'spec_helper'

describe "hoges/edit" do
  before(:each) do
    @hoge = assign(:hoge, stub_model(Hoge,
      :titile => "MyString",
      :comment => ""
    ))
  end

  it "renders the edit hoge form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", hoge_path(@hoge), "post" do
      assert_select "input#hoge_titile[name=?]", "hoge[titile]"
      assert_select "input#hoge_comment[name=?]", "hoge[comment]"
    end
  end
end
