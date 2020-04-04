require 'rails_helper'

RSpec.describe "Things", type: :request do
  include_context "db_cleanup_each" 
  let(:account){ signup FactoryGirl.attributes_for(:user) }


  context "API check" do
    let!(:user) { login account }
    it_should_behave_like "resource index", :thing
    it_should_behave_like "resource show", :thing
    it_should_behave_like "resource create", :thing
    it_should_behave_like "resource modify", :thing
  end

  shared_examples "cannot create" do
    it "create fails" do
      jpost things_path, thing_attributes
      expect(response.status).to be >= 400
      expect(response.status).to be <= 500
      expect(parsed_body).to include("errors")
    end
  end

  shared_examples "can create" do
    it "can create" do
      jpost things_path, thing_attributes
      expect(response).to have_http_status(:created)
      payload=parsed_body
      expect(payload).to include("id")
      expect(payload).to include("name" => thing_attributes[:name])
    end

    it "will report error when invalid data (missing name)" do
      jpost things_path, thing_attributes.except(:name)
      expect(response).to have_http_status(:bad_request)
      payload=parsed_body
      expect(payload).to have_key("errors")
      expect(payload["errors"]).to have_key("full_messages")
      expect(payload["errors"]["full_messages"][0]).to include("can't be blank")
    end
  end

  shared_examples "all fields present" do
    it "list has all fields" do
      jget things_path
      expect(response).to have_http_status(:ok)
      payload=parsed_body
      expect(payload.size).to_not eq(0)
      payload.each do |r|
        expect(r).to include("id")
        expect(r).to include("name")
        expect(r).to include("description")
        expect(r).to include("notes")
      end
    end

    it "get has all fields" do
      jget thing_path(thing.id)
      expect(response).to have_http_status(:ok)
      payload=parsed_body
      expect(parsed_body).to include("id"=>thing.id)
      expect(parsed_body).to include("name"=>thing.name)
      expect(parsed_body).to include("description"=>thing.description)
      expect(parsed_body).to include("notes"=>thing.notes)
    end
  end

  shared_examples "cannot list" do
    it "will report error when anon requests list" do 
      jget things_path
      expect(response.status).to be >= 400
      expect(response.status).to be <= 500
      expect(parsed_body).to include("errors")
      expect(parsed_body["errors"]).to include(/Authorized users only./)
    end
  end

  describe "access" do
    let(:things_attributes) { (1..3).map {FactoryGirl.attributes_for(:thing, :with_description)} }
    let(:thing_attributes) { things_attributes[0] }
    let!(:things) { Thing.create(things_attributes) }
    let(:thing) { things[0] }

    # unauthenticated caller can't create but can call index and show to see things
    context "unauthenticated caller" do
      before(:each) { logout nil }
      it_should_behave_like "cannot create"
      it_should_behave_like "cannot list"
    end

    context "authenticated called" do
      let!(:user) { login account }
      it_should_behave_like "can create"
      it_should_behave_like "all fields present"
    end
  end

end
