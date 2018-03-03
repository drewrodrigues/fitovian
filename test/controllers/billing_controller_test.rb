require 'test_helper'

class BillingControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get charges_new_path
    assert_response :success
  end

  test "should get update" do
    get charges_update_path
    assert_response :success
  end
end
