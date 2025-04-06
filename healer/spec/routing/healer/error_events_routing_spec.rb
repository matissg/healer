require "rails_helper"

RSpec.describe Healer::ErrorEventsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/healer/error_events").to route_to("healer/error_events#index")
    end

    it "routes to #new" do
      expect(get: "/healer/error_events/new").to route_to("healer/error_events#new")
    end

    it "routes to #show" do
      expect(get: "/healer/error_events/1").to route_to("healer/error_events#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/healer/error_events/1/edit").to route_to("healer/error_events#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/healer/error_events").to route_to("healer/error_events#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/healer/error_events/1").to route_to("healer/error_events#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/healer/error_events/1").to route_to("healer/error_events#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/healer/error_events/1").to route_to("healer/error_events#destroy", id: "1")
    end
  end
end
