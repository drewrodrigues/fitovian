require "rails_helper"

RSpec.describe StacksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/stacks").to route_to("stacks#index")
    end

    it "routes to #new" do
      expect(:get => "/stacks/new").to route_to("stacks#new")
    end

    it "routes to #show" do
      expect(:get => "/stacks/1").to route_to("stacks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/stacks/1/edit").to route_to("stacks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/stacks").to route_to("stacks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/stacks/1").to route_to("stacks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/stacks/1").to route_to("stacks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/stacks/1").to route_to("stacks#destroy", :id => "1")
    end

  end
end
