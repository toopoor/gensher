require "spec_helper"

describe InformesController do
  describe "routing" do

    it "routes to #index" do
      get("/informes").should route_to("informes#index")
    end

    it "routes to #new" do
      get("/informes/new").should route_to("informes#new")
    end

    it "routes to #show" do
      get("/informes/1").should route_to("informes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/informes/1/edit").should route_to("informes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/informes").should route_to("informes#create")
    end

    it "routes to #update" do
      put("/informes/1").should route_to("informes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/informes/1").should route_to("informes#destroy", :id => "1")
    end

  end
end
