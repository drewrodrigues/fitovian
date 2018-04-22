require 'rails_helper'

RSpec.describe "stacks/new", type: :view do
  before(:each) do
    assign(:stack, Stack.new(
      :title => "MyString",
      :category => nil
    ))
  end

  it "renders new stack form" do
    render

    assert_select "form[action=?][method=?]", stacks_path, "post" do

      assert_select "input[name=?]", "stack[title]"

      assert_select "input[name=?]", "stack[category_id]"
    end
  end
end
