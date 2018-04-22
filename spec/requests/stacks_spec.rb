require 'rails_helper'

RSpec.describe "Stacks", type: :request do
  describe "GET /stacks" do
    it "works! (now write some real specs)" do
      get stacks_path
      expect(response).to have_http_status(200)
    end
  end
end
