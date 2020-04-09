module CityUiHelper
  CITY_FORM_XPATH="//h3[text()='Cities']/../form"
  CITY_LIST_XPATH="//h3[text()='Cities']/../ul"

  def create_city city_attributes
    visit "#{root_path}/#/" unless page.has_css?("h3", text:"Cities")
    expect(page).to have_css("h3", text:"Cities")
    within(:xpath,CITY_FORM_XPATH) do
      fill_in("name", :with=>city_attributes[:name])
      click_button("Create City")
    end
    within(:xpath,CITY_LIST_XPATH) do
      expect(page).to have_css("li a", text: city_attributes[:name], wait: 5)
    end
  end

  def update_city existing_name, new_name
    visit "#{root_path}/#/" unless page.has_css?("h3", text:"Cities")
    expect(page).to have_css("h3", text:"Cities")
    within(:xpath,CITY_LIST_XPATH) do
      find("a",text:existing_name).click
    end
    within(:xpath,CITY_FORM_XPATH) do
      fill_in("name", with:new_name)
      click_button("Update City")
    end
    within(:xpath,CITY_LIST_XPATH) do
      expect(page).to have_css("li a", text:new_name)
    end
  end

  def delete_city name
    visit "#{root_path}/#/" unless page.has_css?("h3", text:"Cities")
    expect(page).to have_css("h3", text:"Cities")
    within(:xpath, CITY_LIST_XPATH) do
      find("li a", text:name).click
    end
    find(:xpath, "//button[@ng-click='citiesVM.destroy()']").click
    within(:xpath, CITY_LIST_XPATH) do
      expect(page).to have_no_css("li a", text:name)
    end
  end
end