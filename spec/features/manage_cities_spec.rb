require 'rails_helper'
require 'support/city_ui_helper.rb'

RSpec.feature "ManageCities", type: :feature, :js => true do
  include_context "db_cleanup_each"
  include CityUiHelper
  CITY_FORM_XPATH=CityUiHelper::CITY_FORM_XPATH
  CITY_LIST_XPATH=CityUiHelper::CITY_LIST_XPATH
  let(:city_attributes){ FactoryGirl.attributes_for(:city) }


  feature "view existing Cities" do
    let(:cities) { (1..5).map{ FactoryGirl.create(:city) }.sort_by { |v| v["name"]} }

    scenario "when no instances exist" do
      visit root_path
      within(:xpath,CITY_LIST_XPATH) do             # waits for ul tag
        expect(page).to have_no_css("li")           # waits for ul li tag
        expect(page).to have_css("li", count:0)     # waits for ul li tag
        expect(all("ul li").size).to eq(0)          # doesn't wait
      end
    end

    scenario "when instances exist" do
      visit root_path if cities                     #loading the let here in an if statement, instead of making the let eager
      within(:xpath,CITY_LIST_XPATH) do
        expect(page).to have_css("li:nth-child(#{cities.count})") # waits for the nth li to load
        expect(page).to have_css("li", count:cities.count)        # waits for ul li tag
        expect(all("li").size).to eq(cities.count)                # doesn't wait
        cities.each_with_index do |city, index|
          expect(page).to have_css("li:nth-child(#{index+1})", :text=>city.name)
        end
      end
    end
  end

  context "add new City" do
    #Background and before are synonymous.
    #At the beginning of each test we make sure that we visit the root
    #On the Cities page
    #And nothing is listed yet
    background(:each) do
      visit root_path
      expect(page).to have_css("h3", text:"Cities")
      within(:xpath, CITY_LIST_XPATH) do
        expect(page).to have_css("li", count:0)
      end
    end

    it "has input form" do
      expect(page).to have_css("label", text: "Name:")
      expect(page).to have_css("input[name='name'][ng-model='citiesVM.city.name']")
      expect(page).to have_css("input[name='name'][ng-model*='city.name']")
      expect(page).to have_button("Create City")
    end

    it "complete form" do 
      within(:xpath,CITY_FORM_XPATH) do
        fill_in("name", :with=>city_attributes[:name])
        click_button("Create City")
      end
      within(:xpath,CITY_LIST_XPATH) do
        using_wait_time 5 do
          expect(page).to have_css("li", count:1)
          expect(page).to have_content(city_attributes[:name])
        end
      end
    end

    it "complete form with xpath" do 
      find(:xpath, "//input[@ng-model='citiesVM.city.name']").set(city_attributes[:name])
      #find(:xpath,"//input[contains(@ng-model,'city.name')]").set(city_attributes[:name])
      find(:xpath, "//button[@ng-click='citiesVM.create()']").click
      within(:xpath, CITY_LIST_XPATH) do
        using_wait_time 5 do
          expect(page).to have_xpath(".//li", count:1)
          expect(page).to have_content(city_attributes[:name])
        end
      end
    end

    it "complete form with helper module" do
      create_city city_attributes

      within(:xpath, CITY_LIST_XPATH) do
        expect(page).to have_css("li", count:1)
      end
    end
  end

  context "with existing City" do
    background(:each) do
      create_city city_attributes
    end

    it "can be updated" do
      existing_name = city_attributes[:name]
      new_name = FactoryGirl.attributes_for(:city)[:name]
      within(:xpath, CITY_LIST_XPATH) do
        expect(page).to have_css("li", count:1)
        expect(page).to have_css("li", text:existing_name)
        expect(page).to have_no_css("li", text:new_name)
      end

      update_city(existing_name, new_name)

      within(:xpath, CITY_LIST_XPATH) do
        expect(page).to have_css("li", count:1)
        expect(page).to have_no_css("li", text:existing_name)
        expect(page).to have_css("li", text:new_name)
      end
    end

    it "can be deleted" do
      within(:xpath, CITY_LIST_XPATH) do
        expect(page).to have_css("a", text:city_attributes[:name])
      end

      delete_city city_attributes[:name]

      within(:xpath, CITY_LIST_XPATH) do
        expect(page).to have_no_css("a", text:city_attributes[:name])
      end
    end
  end
end
