require 'rails_helper'

RSpec.describe "ThingTypes", type: :request do
  include_context "db_cleanup_each"
  let(:originator) { apply_originator(signup(FactoryGirl.attributes_for(:user)), Thing) }
  let(:account)  { signup FactoryGirl.attributes_for(:user) }
	let(:thing_props)   { FactoryGirl.attributes_for(:thing, :with_fields) }
  let(:thing_resources) { 3.times.map { create_resource things_path, :thing } }
	let(:thing_id)   { thing_resources[0]["id"] }
  let(:thing)      { Thing.find(thing_id) }
  let(:thing_type) { ThingType.first}
  before (:each) do
  	login originator
  	thing_resources
  	thing_type
  end
    
  context "authenticated user" do
  	let!(:user) { login account }

  	it "will list all thing types" do 
      jget thing_types_path
      #pp parsed_body
      expect(response).to have_http_status(:ok)
      expect(parsed_body.size).to eq(thing_resources.count)
      if (thing_resources.count > 0)
	      parsed_body.each do |thing_type, index|
	        expect(thing_type).to include("id")
	        expect(thing_type).to include("description")
	        expect(thing_type).to include("name")
	      end
      end
    end

  	it "will show a thing_type and its properties and list things by type" do 
  		jget thing_type_path(thing_type.id) 
  		# pp parsed_body
  		expect(response).to have_http_status(:ok)
  		expect(parsed_body).to include("id")
  		expect(parsed_body).to include("name")
  		expect(parsed_body).to include("description")
  		expect(parsed_body).to include("url" => /.+thing_types.+/)
  		jget typed_things_thing_type_path(thing_type.id)
  		expect(response).to have_http_status(:ok)
  		# pp parsed_body
  		parsed_body.each do |thing|
	  		expect(thing).to include("id")
	  		expect(thing).to include("name")
	  		expect(thing).to include("description")
	  		expect(thing).to include("url" => /.+things.+/)
	  	end

  	end
  	it "will show a thing_type when viewing a thing" do 
  		jget thing_path(thing_id)
  		# pp parsed_body
  		expect(response).to have_http_status(:ok)
  		expect(parsed_body).to include("id"=>thing_id)
  		expect(parsed_body).to include("thing_type_id")
  	end
  	it "will not update a thing's type" do
  		jput thing_path(thing_id), thing_props
  		expect(response).to have_http_status(:forbidden)
  	end
  end

  context "unauthenticated user" do
    before(:each) do 
      logout
    end
  	it "will not list thing types" do
      jget thing_types_path
      expect(response).to have_http_status(:unauthorized)
  	end
  	it "will not show thing types" do
  		jget thing_type_path(thing_type.id) 
  		expect(response).to have_http_status(:unauthorized)
  	end
  	it "will not show thing_type of a specific thing" do
  		jget thing_path(thing_id)
  		expect(response).to have_http_status(:ok)
  		expect(parsed_body).to_not include(:thing_type_id)
  	end
  	it "will not update a thing's type" do
  		jput thing_path(thing_id, thing_props)
  		expect(response).to have_http_status(:unauthorized)
  	end
  end

  context "organizer user" do
    let(:user) { apply_originator(login(account), Thing) }
  	it "can change a thing's type" do
  		jput thing_path(thing["id"]), FactoryGirl.attributes_for(:thing, :with_fields)
  		expect(response).to have_http_status(:no_content)
  	end
  end
end