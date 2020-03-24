require 'rails_helper'

describe "Cities API", type: :request do
  include_context "db_cleanup_each", :transaction

  context "caller requests list of Cities" do
    let!(:cities) { (1..5).map {|x| FactoryGirl.create(:city) } }

    it "returns all instancs" do
      get cities_path, {:sample1=>"param", :sample2=>"param"}, {"Accept" =>"application/json"}

      expect(request.method).to eq("GET")
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json")
      expect(response["X-Frame-Options"]).to eq("SAMEORIGIN")

      payload=parsed_body
      expect(payload.count).to eq(cities.count)
      expect(payload.map{ |f| f["name"] }).to eq(cities.map{ |f| f[:name]}) 
    end
  end

  context "a specific City exists" do
    let(:city) { FactoryGirl.create(:city) }
    let(:bad_city) { 123456798 }

    it "returns City when using correct ID" do
      get city_path(city.id)
      expect(response).to have_http_status(:ok)

      payload=parsed_body
      pp payload
      expect(payload).to have_key("id")
      expect(payload).to have_key("name")
      expect(payload["id"]).to eq(city.id)
      expect(payload["name"]).to eq(city.name)
    end

    it "returns not found when using incorrect ID" do
      get city_path(bad_city)
      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to eq("application/json")

      payload=parsed_body
      pp payload
      expect(payload).to have_key("errors")
      expect(payload["errors"]).to have_key("full_messages")
      expect(payload["errors"]["full_messages"][0]).to include("cannot find","#{bad_city}")

    end

  end

  context "create a new City" do
    it "can create with provided name"

  end

end
