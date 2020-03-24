require 'rails_helper'

describe City, type: :model do
	include_context "db_cleanup", :transaction
	include_context "db_scope"
	before(:all) do
		#@city = City.create(:name => "test")
		@city = FactoryGirl.create(:city, :name => "test")
	end
	let(:city) { City.find(@city.id) }

	context "created City (let)" do
		it { expect(city).to be_persisted }
		it { expect(city.name).to eq("test") }
		it { expect(City.find(city.id)).to_not be_nil }
	end

	context "created City (subject)" do
		subject { @city }

		it { is_expected.to be_persisted }
		it { expect(subject.name).to eq("test") }
		it { expect(City.find(subject.id)).to_not be_nil }
	end

	context "created City (lazy)" do
		let(:before_count) { City.count }

		it { expect(city).to be_persisted }
		it { expect(city.name).to eq("test") }
		it { expect(City.find(city.id)).to_not be_nil }
		it { city; expect(City.count).to_not eq(before_count + 1) } #won't equal becuz before_count is called mid spec
	end

	context "created City (eager)" do
		let!(:before_count) { City.count }
		let(:city) {City.create(:name => "eager_test") }

		it { expect(city).to be_persisted }
		it {expect(city.name).to eq("eager_test") }
		it {expect(City.find(city.id)).to_not be_nil }
		it { city; expect(City.count).to eq(before_count + 1) } #will equal becuz before_count is called eagerly before spec
	end

end
