require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

require './lib/enrollment'
require './test/test_helper'

class EnrollmentTest < Minitest::Test

  def test_create_enrollment
    district_info = {
      name: "ashleyville",
      kindergarten: { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 }
    }

    district = Enrollment.new(district_info)

    district_data = { kindergarten: { 2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677 } }
    assert_equal "ASHLEYVILLE", district.name
    assert_equal district_data, district.data
  end

end