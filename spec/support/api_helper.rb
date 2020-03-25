module ApiHelper
  def parsed_body
    JSON.parse(response.body)
  end

  # def jpost(path, params={}, headers={})
  #   headers = headers.merge('Content-type' => 'application/json') if !params.empty?
  #   post(path, params.to_json, headers)
  # end

  # def jput(path, params={}, headers={})
  #   headers = headers.merge('content-type'=>'application/json') if !params.empty?
  #   put(path, params.to_json, headers)
  # end

  ["post", "put"].each do |http_method_name|
    define_method("j#{http_method_name}") do |path,params={},headers={}|
      headers=headers.merge('content-type'=>'application/json') if !params.empty?
      self.send(http_method_name, path, params.to_json, headers)
    end
  end
end


RSpec.shared_examples "resource index" do |model|
  let!(:resources) { (1..5).map {|idx| FactoryGirl.create(model) } }
  let(:payload) { parsed_body }

  it "returns all #{model} instances" do
    get send("#{model}s_path"), {}, {"Accept"=>"application/json"}
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")

    expect(payload.count).to eq(resources.count)
    response_check if respond_to?(:response_check)
  end
end


RSpec.shared_examples "resource show" do |model|
  let(:resource) { FactoryGirl.create(model) }
  let(:bad_id) { 123456789 }
  let(:payload) { parsed_body }

  it "returns #{model} when using a correct ID" do
    get send("#{model}_path", resource.id)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")

    response_check if respond_to?(:response_check)
  end

  it "returns not found when using a bad ID" do
    get send("#{model}_path", bad_id)
    expect(response).to have_http_status(:not_found)
    expect(response.content_type).to eq("application/json")


    expect(payload).to have_key("errors")
    expect(payload["errors"]).to have_key("full_messages")
    expect(payload["errors"]["full_messages"][0]).to include("cannot find","#{bad_id}")
  end
end


RSpec.shared_examples "create a new resource" do |model|
  let(:resource_attributes) { FactoryGirl.attributes_for(model) }
  let(:payload) { parsed_body }

  it "can create #{model} with provided name" do
    jpost send("#{model}s_path"), resource_attributes
    expect(response).to have_http_status(:created)
    expect(response.content_type).to eq(:json)

    #verify payload has ID
    expect(payload).to have_key("id")
    response_check if respond_to?(:response_check)
   
    #verify we can locate the created instance in DB
    get send("#{model}_path", payload["id"])
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples "modifiable resource" do |model|
  let(:resource) { FactoryGirl.create(model) }
  let(:new_attribute) { FactoryGirl.attributes_for(model) }

  it "can update #{model}" do
    #change to the new attribute
    jput send("#{model}_path", resource.id), new_attribute
    expect(response).to have_http_status(:no_content)

    response_check if respond_to?(:response_check)
  end

  it "can be deleted" do
    #head request is the same as GET, except that it only responds with headers
    head send("#{model}_path", resource.id)
    expect(response).to have_http_status(:ok)

    #issue delete
    delete send("#{model}_path", resource.id)
    expect(response).to have_http_status(:no_content)

    head send("#{model}_path", resource.id)
    expect(response).to have_http_status(:not_found)
  end
end
