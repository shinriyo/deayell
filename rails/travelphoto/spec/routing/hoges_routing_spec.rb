require "spec_helper"

describe HogesController do
  describe "routing" do

    it "routes to #index" do
      get("/hoges").should route_to("hoges#index")
    end

    it "routes to #new" do
      get("/hoges/new").should route_to("hoges#new")
    end

    it "routes to #show" do
      get("/hoges/1").should route_to("hoges#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hoges/1/edit").should route_to("hoges#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hoges").should route_to("hoges#create")
    end

    it "routes to #update" do
      put("/hoges/1").should route_to("hoges#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hoges/1").should route_to("hoges#destroy", :id => "1")
    end

  end
end
