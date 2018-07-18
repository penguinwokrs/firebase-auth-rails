require 'test_helper'

class Firebase::Auth::Rails::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Firebase::Auth::Rails
  end
end
