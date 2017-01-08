require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

require './lib/district_repository'
require './test/test_helper'

class DistrictRepositoryTest < Minitest::Test

  def test_create
    dr = setup

    assert_equal Hash.new,                  dr.data_scheme_links
    assert_equal EnrollmentRepository,      dr.repository_links[:enrollment].class
    assert_equal StatewideTestRepository,   dr.repository_links[:statewide_testing].class
    assert_equal EconomicProfileRepository, dr.repository_links[:economic_profile].class
  end

  def test_create_districts_small_data
    dr = setup
    extractor = dr.load_hash_extractor(CSVFiles.small_data_set)
    district_list = [{:name=>"ASHLEYVILLE"}, {:name=>"COLORADO"}, {:name=>"GREGVILLE"}, {:name=>"TURINGTOWN"}]

    dr.create_districts(district_list)

    assert_equal 4,    dr.data_scheme_links.length
    assert_equal true, dr.data_scheme_links.all? { |district_name, district| district.class == District }
  end

  def test_load_data
    dr = setup

    dr.load_data(CSVFiles.small_data_set)

    assert_equal 4,    dr.data_scheme_links.length
    assert_equal true, dr.data_scheme_links.all? { |district_name, district| district.class == District }
  end

  def setup
    DistrictRepository.new
  end

end