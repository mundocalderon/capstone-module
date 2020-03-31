require 'rails_helper'

RSpec.describe "Images", type: :request do
  include_context "db_cleanup_each" 
  let(:account){ signup FactoryGirl.attributes_for(:user) }


  context "API check" do
    let!(:user) { login account }
    it_should_behave_like "resource index", :image
    it_should_behave_like "resource show", :image
    it_should_behave_like "resource create", :image
    it_should_behave_like "resource modify", :image
  end

  shared_examples "cannot create" do
    it "create fails" do
      jpost images_path, image_attributes
      expect(response.status).to be >= 400
      expect(response.status).to be <= 500
      expect(parsed_body).to include("errors")
    end
  end

  shared_examples "can create" do
    it "can create" do
      jpost images_path, image_attributes
      expect(response).to have_http_status(:created)
      payload=parsed_body
      expect(payload).to include("id")
      expect(payload).to include("caption" => image_attributes[:caption])
    end
  end

  shared_examples "all fields present" do
    it "list has all fields" do
      jget images_path
      expect(response).to have_http_status(:ok)
      payload=parsed_body
      expect(payload.size).to_not eq(0)
      payload.each do |r|
        expect(r).to include("id")
        expect(r).to include("caption")
      end
    end

    it "get has all fields" do
      jget image_path(image.id)
      expect(response).to have_http_status(:ok)
      payload=parsed_body
      expect(parsed_body).to include("id"=>image.id)
      expect(parsed_body).to include("caption"=>image.caption)
    end
  end

  describe "access" do
    let(:images_attributes) { (1..3).map {FactoryGirl.attributes_for(:image, :with_caption)} }
    let(:image_attributes) { images_attributes[0] }
    let!(:images) { Image.create(images_attributes) }
    let(:image) { images[0] }

    # unauthenticated caller can't create but can call index and show to see images
    context "unauthenticated caller" do
      before(:each) { logout nil }
      it_should_behave_like "cannot create"
      it_should_behave_like "all fields present"
    end

    context "authenticated called" do
      let!(:user) { login account }
      it_should_behave_like "can create"
      it_should_behave_like "all fields present"
    end
  end
end
