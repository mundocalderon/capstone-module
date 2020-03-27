require 'rails_helper'

RSpec.feature "Mainpages", type: :feature, :js=>true do

  context "when the main page is accessed" do
    before(:each) do
      visit "/"
    end
    it "displays the index.html launch page" do
      #save_and_open_screenshot ## poltergeist and selenium offer these neat methods
      #expect(page).to have_content("Hello (from app/views/ui/index.html.erb)")
      expect(page).to have_content(/Hello \(from .+index.html.*\)/)
      #save_and_open_page ## poltergeist and selenium offer these neat methods
    end
    it "index page has bootstrap styling" do
      expect(page).to have_css("div.container")
    end
    it "displays the main application page" do
      expect(page).to have_content("Sample App (from capstone/pages/main.html)")
    end
    it "displays the cities tile" do
      expect(page).to have_content("Cities (from capstone/cities/cities.html)")
    end
  end
end

