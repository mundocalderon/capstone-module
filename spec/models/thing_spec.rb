require 'rails_helper'

RSpec.describe Thing, type: :model do
  include_context "db_cleanup"

  context "build valid Thing" do
    it "will be valid with name" do
      thing = FactoryGirl.build(:thing)
      expect(thing.name).to_not be_nil
      expect(thing.save).to be true
    end
    
    it "will be valid with name and description" do
      thing=FactoryGirl.build(:thing, :with_description)
      expect(thing.name).to_not be_nil
      expect(thing.description).to_not be_nil
      expect(thing.save).to be true
    end

    it "will be valid with name and no description" do
      thing=FactoryGirl.build(:thing, description:nil)
      expect(thing.name).to_not be_nil
      expect(thing.description).to be_nil
      expect(thing.save).to be true
    end
  end

  context "invalid Thing" do
    it "is not created without a name" do
      thing = FactoryGirl.build(:thing, :name => nil)
      expect(thing.validate).to be false
      expect(thing.errors.messages).to include(:name=>["can't be blank"])
    end
  end
end
