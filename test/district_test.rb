require './test/test_helper'
require './lib/district'
require './lib/economic_profile'
require './lib/enrollment'
require './lib/statewide_test'

class DistrictTest <  Minitest::Test

  def test_create_district
    district = District.new({name: "ashleyville"})

    assert_equal "ASHLEYVILLE", district.name
    assert_equal Hash.new,      district.data
  end

  def test_add_connection
    district_name = {name: "ashleyville"}
    district = District.new(district_name)
    enrollment = Enrollment.new(district_name)

    district.create_connection(:enrollment, enrollment)

    district_data = {:enrollment => enrollment}
    assert_equal "ASHLEYVILLE",   district.name
    assert_equal district_data,  district.data
  end

  def test_enrollment_link
    district = District.new({name: "ashleyville"})
    enrollment = Enrollment.new({name: "ashleyville"})
    district.create_connection(:enrollment, enrollment)

    assert_equal enrollment, district.enrollment
  end

  def test_economic_profile_link
    district = District.new({name: "ashleyville"})
    economic_profile = EconomicProfile.new({name: "ashleyville"})
    district.create_connection(:economic_profile, economic_profile)

    assert_equal economic_profile, district.economic_profile
  end

  def test_statewide_test_link
    district = District.new({name: "ashleyville"})
    statewide_test = StatewideTest.new({name: "ashleyville"})
    district.create_connection(:statewide_test, statewide_test)

    assert_equal statewide_test, district.statewide_test
  end

    def test_enrollment_nil
    district = District.new({name: "ashleyville"})

    assert_nil district.enrollment
  end

  def test_economic_profile_nil
    district = District.new({name: "ashleyville"})

    assert_nil district.economic_profile
  end

  def test_statewide_test_nil
    district = District.new({name: "ashleyville"})

    assert_nil district.statewide_test
  end

end