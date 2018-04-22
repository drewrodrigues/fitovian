require 'rails_helper'

RSpec.describe "stacks/edit", type: :view do
  before(:each) do
    @stack = assign(:stack, Stack.create!(
      :title => "MyString",
      :category => nil
    ))
  end

  it "renders the edit stack form" do
    render

    assert_select "form[action=?][method=?]", stack_path(@stack), "post" do

      assert_select "input[name=?]", "stack[title]"

      assert_select "input[name=?]", "stack[category_id]"
    end
  end
end
