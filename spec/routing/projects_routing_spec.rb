require "spec_helper"

describe ProjectsController do
  describe "routing" do

    it "routes to #index" do
      expect(get "/p").to route_to("projects#index")
    end

    it "routes to #new" do
      expect(get "/p/new").to route_to("projects#new")
    end

    it "routes to #show" do
      expect(get "/p/project_name").to route_to("projects#show", id: "project_name")
    end

    it "routes to #edit" do
      expect(get "/p/project_name/edit").to route_to("projects#edit", id: "project_name")
    end

    it "routes to #create" do
      expect(post "/p").to route_to("projects#create")
    end

    it "routes to #update" do
      expect(put "/p/project_name").to route_to("projects#update", id: "project_name")
    end

    it "routes to #destroy" do
      expect(delete "/p/project_name").to route_to("projects#destroy", id: "project_name")
    end

  end
end
