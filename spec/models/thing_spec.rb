require 'rails_helper'

RSpec.describe Thing, type: :model do
  include_context "db_cleanup_each"

  context "valid thing" do
    let(:thing) { FactoryGirl.create(:thing) }
    let(:thing_types) {FactoryGirl.create_list(:thing_type, 3)}


    it "creates new instance" do
      db_thing=Thing.find(thing.id)
      expect(db_thing.name).to eq(thing.name)
    end

    it "creates new instance with a pre-existing type" do
      thing_types
      db_thing= FactoryGirl.create(:thing, :thing_type => ThingType.last)
      expect(db_thing.thing_type).to eq(ThingType.last)
      expect(db_thing.thing_type.id).to eq(ThingType.count)
    end
  end

  context "invalid thing" do
    let(:thing) { FactoryGirl.build(:thing, :name=>nil) }

    it "provides error messages" do
      expect(thing.validate).to be false
      expect(thing.errors.messages).to include(:name=>["can't be blank"])
    end
  end
end
