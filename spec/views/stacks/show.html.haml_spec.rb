require 'rails_helper'

RSpec.describe "stacks/show", type: :view do
  before(:each) do
    @stack = assign(:stack, Stack.create!(
      :title => "Title",
      :category => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(//)
  end
end
