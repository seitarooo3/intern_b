require 'test_helper'

class WorksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get works_create_url
    assert_response :success
  end

end
