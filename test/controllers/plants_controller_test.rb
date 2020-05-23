require 'test_helper'

class PlantsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @plant = plants(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Plant.count' do
      post plants_path, params: { plant: { name: "Lorem ipsum",
                                           name_latin: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Plant.count' do
      delete plant_path(@plant)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong plant" do
    log_in_as(users(:michael))
    @plant = plants(:two)
    assert_no_difference 'Plant.count' do
      delete plant_path(@plant)
    end
    assert_redirected_to root_url
  end
end
