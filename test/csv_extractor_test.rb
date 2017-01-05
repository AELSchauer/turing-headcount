require './lib/csv_extractor'

require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

class CSVExtractorTest < Minitest::Test

  def test_load
    file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
    csv = CSVExtractor.new(file_path)

    assert_equal :location,   csv.headers[0]
    assert_equal :timeframe,  csv.headers[1]
    assert_equal :dataformat, csv.headers[2]
    assert_equal :data,       csv.headers[3]
    assert_equal "Colorado",  csv.contents[0][:location]
    assert_equal "2010",      csv.contents[0][:timeframe]
    assert_equal "Percent",   csv.contents[0][:dataformat]
    assert_equal "0.724",     csv.contents[0][:data]
  end

  def test_district_list
    file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
    csv = CSVExtractor.new(file_path)
    districts = ["Colorado", "ASHLEYVILLE", "GREGVILLE"]

    assert_equal districts, csv.district_list
  end

  def test_data_hash
    file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
    csv = CSVExtractor.new(file_path)
    data = {
      "COLORADO" =>    {"2010"=>"0.724", "2011"=>"0.739", "2012"=>"0.75354", "2013"=>"0.769", "2014"=>"0.773"},
      "ASHLEYVILLE" => {"2010"=>"0.895", "2011"=>"0.895", "2012"=>"0.88983", "2013"=>"0.91373", "2014"=>"0.898"},
      "GREGVILLE" =>   {"2010"=>"0.57", "2011"=>"0.608", "2012"=>"0.63372", "2013"=>"0.59351", "2014"=>"0.659"}
    }

    assert_equal data, csv.data_hash
  end

end