require 'test_helper'

class PlantTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @plant = @user.plants.build(
      name: "Cabbage, Primo Vantage", 
      name_latin: "Brassica oleracea var. capitata"
    )
  end

  test "should be valid" do
    assert @plant.valid?
  end

  test "user id should be present" do
    @plant.user_id = nil
    assert_not @plant.valid?
  end

  test "name should be present" do
    @plant.name = "  "
    assert_not @plant.valid?
  end

  test "name should not be too long" do
    @plant.name = "a" * 31
    assert_not @plant.valid?
  end

  test "latin name should be present" do
    @plant.name_latin = "   "
    assert_not @plant.valid?
  end

  test "latin name should not be too long" do
    @plant.name_latin = "a" * 51
    assert_not @plant.valid?
  end

end
