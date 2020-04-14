require 'rails_helper'
#Mongo::Logger.logger.level = ::Logger::DEBUG


describe "States API", type: :request do
  include_context "db_cleanup_each"

  context "caller requests list of States" do
    it_should_behave_like "resource index", :state do
      let(:response_check) do
        expect(payload.count).to eq(resources.count);
        expect(payload.map{|f|f["name"]}).to eq(resources.map{|f|f[:name]})
        #pp "PAYLOAD GOOD!!!"
        #binding.pry
      end
    end

  end

  context "a specific State exists" do
    it_should_behave_like "resource show", :state do
      let(:response_check) do
        expect(payload).to have_key("id")
        expect(payload).to have_key("name")
        expect(payload["id"]).to eq(resource.id.to_s)
        expect(payload["name"]).to eq(resource.name)
      end
    end

  end

  context "create a new State" do
    # let(:state_attributes) { FactoryGirl.attributes_for(:state) }

    # it "can create with provided name" do
    #   jpost states_path, state_attributes
    #   expect(response).to have_http_status(:created)
    #   expect(response.content_type).to eq(:json)

    #   #check the payload of the response
    #   pp parsed_body 
    #   payload=parsed_body
    #   expect(payload).to have_key("id")
    #   expect(payload).to have_key("name")
    #   expect(payload["name"]).to eq(state_attributes[:name]) 
    #   id=payload["id"]

    #   #verify we can locate the created instance in the DB
    #   expect(State.find(id)).to_not be_nil
    #   expect(State.find(id).name).to eq(state_attributes[:name])
    # end

    it_should_behave_like "resource create", :state do
      let(:response_check) do
        # pp payload
        expect(payload).to have_key("name")
        expect(payload["name"]).to eq(resource_attributes[:name])

        #verify we can locate specific instance in DB
        expect(State.find(payload["id"]).name).to eq(resource_attributes[:name])
      end
    end
  end

  context "existing State" do

    it_should_behave_like "resource modify", :state do
      let(:response_check) do
        #verify that name is not yet new_attribute
        expect(resource["name"]).to_not eq(new_attribute[:name])
        #verify we can locate the created instance in DB
        expect(State.find(resource["id"]).name).to eq(new_attribute[:name])
      end
    end


    # let(:state) { FactoryGirl.create(:state) }
    # let(:new_name) { "testing" }

    # it "can update name" do
    #   #verify that name is not yet new_name
    #   expect(state.name).to_not eq(new_name)

    #   #change to the new name
    #   jput state_path(state.id), {:name=>new_name}
    #   expect(response).to have_http_status(:no_content)

    #   #verify we can locate the created instance in DB
    #   expect(State.find(state.id).name).to eq(new_name)
    # end

    # it "can be deleted" do
    #   #head request is the same as GET, except that it only responds with headers
    #   head state_path(state.id)
    #   expect(response).to have_http_status(:ok)

    #   #issue delete
    #   delete state_path(state.id)
    #   expect(response).to have_http_status(:no_content)

    #   head state_path(state.id)
    #   expect(response).to have_http_status(:not_found)
    # end
  end
end
