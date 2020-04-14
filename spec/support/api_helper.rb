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

  ["post", "put", "patch", "get", "head", "delete"].each do |http_method_name|
    define_method("j#{http_method_name}") do |path,params={},headers={}|
      if ["post", "put", "patch"].include? http_method_name
        headers=headers.merge('content-type'=>'application/json') if !params.empty?
        params = params.to_json
      end
      request= self.send(http_method_name, 
                path, 
                params, 
                headers.merge(access_tokens))
    end
  end

  def signup registration, status=:ok
    jpost user_registration_path, registration
    expect(response).to have_http_status(status)  
    payload=parsed_body
    if response.ok?
      registration.merge(:id=>payload["data"]["id"], :uid=>payload["data"]["uid"])
    else
      payload
    end
  end

  def login credentials, status=:ok
    jpost user_session_path, credentials.slice(:email, :password)
    expect(response).to have_http_status(status)
    return response.ok? ? parsed_body["data"] : parsed_body
  end

  def logout status=:ok
    jdelete destroy_user_session_path
    @last_tokens = {}
    expect(response).to have_http_status(status) if status
  end

  def access_tokens?
    !response.headers["access-token"].nil? if response
  end

  def access_tokens
    if access_tokens?
      # @last_tokens=["uid","client","token-type","access-token"].inject({}) {|h,k| h[k]=response.headers[k] ; h }
      @last_tokens=response.headers.slice("uid","client","token-type","access-token")  

    end
    @last_tokens || {}
  end

  def create_resource path, factory, status=:created
    jpost path, FactoryGirl.attributes_for(factory)
    expect(response).to have_http_status(status) if status
    parsed_body
  end

  def apply_admin account
    User.find(account[:id]).roles.create(:role_name=>Role::ADMIN)
    return account
  end
  def apply_originator account, model_class
    User.find(account[:id]).add_role(Role::ORIGINATOR, model_class).save
    return account
  end
  def apply_role account, role, object
    user=User.find(account[:id])
    arr=object.kind_of?(Array) ? object : [object]
    arr.each do |m|
      user.add_role(role, m).save
    end
    return account
  end
  def apply_organizer account, object
    apply_role(account,Role::ORGANIZER, object)
  end
  def apply_member account, object
    apply_role(account, Role::MEMBER, object)
  end
end

RSpec.shared_examples "resource index" do |model|
  let!(:resources) { (1..5).map {|idx| FactoryGirl.create(model) } }
  let(:payload) { parsed_body }

  it "returns all #{model} instances" do
    jget send("#{model}s_path"), {}, {"Accept"=>"application/json"}
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
    jget send("#{model}_path", resource.id)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq("application/json")

    response_check if respond_to?(:response_check)
  end

  it "returns not found when using a bad ID" do
    jget send("#{model}_path", bad_id)
    expect(response).to have_http_status(:not_found)
    expect(response.content_type).to eq("application/json")


    expect(payload).to have_key("errors")
    expect(payload["errors"]).to have_key("full_messages")
    expect(payload["errors"]["full_messages"][0]).to include("cannot find","#{bad_id}")
  end
end


RSpec.shared_examples "resource create" do |model|
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
    jget send("#{model}_path", payload["id"])
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples "modifiable resource" do |model|
  let(:resource) do 
    jpost send("#{model}s_path"), FactoryGirl.attributes_for(model)
    expect(response).to have_http_status(:created)
    parsed_body
  end
  let(:new_state) { FactoryGirl.attributes_for(model) }

  it "can update #{model}" do
      # change to new state
      jput send("#{model}_path", resource["id"]), new_state
      expect(response).to have_http_status(:no_content)

      update_check if respond_to?(:update_check)
    end

  it "can be deleted" do
    jhead send("#{model}_path", resource["id"])
    expect(response).to have_http_status(:ok)

    jdelete send("#{model}_path", resource["id"])
    expect(response).to have_http_status(:no_content)
    
    jhead send("#{model}_path", resource["id"])
    expect(response).to have_http_status(:not_found)
  end
end
