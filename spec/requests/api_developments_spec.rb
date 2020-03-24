require 'rails_helper'

RSpec.describe "ApiDevelopments", type: :request do
  include_context "db_cleanup_each"
  def parsed_body
  	JSON.parse(response.body)
  end

  describe "RDBMS-backed" do

    it "creates a RDBMS-backed model City" do
      object=City.create(:name=>"test")
      expect(City.find(object.id).name).to eq("test")
    end

    it "exposes RDBMS-backed API City resource" do
    	object=City.create(:name=>"test")
    	expect(cities_path).to eq("/api/cities")
    	get city_path(object.id)
    	expect(response).to have_http_status(:ok)
    	expect(parsed_body["name"]).to eq("test")
    end
  end

  describe "MongoDB-backed" do

  	it "creates a MongoDB-backed model" do
  		object=State.create(:name=>"test")
  		expect(State.find(object.id).name).to eq("test")
  	end

  	it "exposes a MongoDB-backed API resource" do
  		object=State.create(:name=>"test")
  		expect(states_path).to eq("/api/states")
  		get state_path(object.id)
  		expect(response).to have_http_status(:ok)
  		expect(parsed_body["name"]).to eq("test")
  		expect(parsed_body).to include("created_at")
  		expect(parsed_body).to include("id"=>object.id.to_s)

  	end
  end
end
