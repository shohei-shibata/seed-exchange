require 'test_helper'

class PlantsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "plants interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Plant.count' do
      post plants_path, params: { plant: { name: "", name_latin: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'  # Correct pagination link
    # Valid submission
    name = "Valid Name"
    name_latin = "Valid latin name"
    assert_difference 'Plant.count', 1 do
      post plants_path, params: { plant: { name: name, name_latin: name_latin } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete plant.
    assert_select 'a', text: 'delete'
    first_plant = @user.plants.paginate(page: 1).first
    assert_difference 'Plant.count', -1 do
      delete plant_path(first_plant)
    end
    # Visit different user (no delete links).
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end
end
