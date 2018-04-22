require 'rails_helper'

RSpec.describe "stacks/index", type: :view do
  before(:each) do
    assign(:stacks, [
      Stack.create!(
        :title => "Title",
        :category => nil
      ),
      Stack.create!(
        :title => "Title",
        :category => nil
      )
    ])
  end

  it "renders a list of stacks" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
