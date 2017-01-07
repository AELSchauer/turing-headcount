require './experimenting_load_hash'

require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

class ExperimentingLoadHashTest < Minitest::Test

  def setup
    ExperimentingLoadHash.new
  end

  def test_create
    elh = setup

    expected_data = {
        :enrollment => {},
        :statewide_testing => {},
        :economic_profile => {}
      }

    assert_equal expected_data, elh.districts_hashes
  end

  def test_extract_csv
    elh = setup

    csv = elh.extract_csv(generic_csv_file(1))

    expected_headers = [:location, :timeframe, :dataformat, :data]

    assert_equal CSV::Table,       csv.class
    assert_equal expected_headers, csv.headers
    assert_equal "gregville",      csv[0][:location]
  end

  def test_determine_headers
    elh = setup
    csv_1 = elh.extract_csv(generic_csv_file(1))
    csv_2 = elh.extract_csv(generic_csv_file(2))
    csv_3 = elh.extract_csv(generic_csv_file(3))

    headers_1 = elh.determine_headers(csv_1)
    headers_2 = elh.determine_headers(csv_2)
    headers_3 = elh.determine_headers(csv_3)

    expected_headers_1 = [:location, :timeframe, :data]
    expected_headers_2 = [:location, :subject, :timeframe, :data]
    expected_headers_3 = [:location, :timeframe, :dataformat, :data]

    assert_equal expected_headers_1, headers_1
    assert_equal expected_headers_2, headers_2
    assert_equal expected_headers_3, headers_3
  end

  def test_create_districts_hashes
    elh, csv = setup_with_generic_csv_file(1)

    elh.create_districts_hashes(:enrollment, csv)

    expected_data = {
        "GREGVILLE"=>{:name=>"GREGVILLE"},
        "ASHLEYVILLE"=>{:name=>"ASHLEYVILLE"}
      }

    assert_equal expected_data, elh.districts_hashes[:enrollment]
  end

  def test_extract_data_from_csv
    elh, csv = setup_with_generic_csv_file(2)

    elh.create_districts_hashes(:enrollment, csv)
    elh.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_2, csv)

    expected_data = {
      "GREGVILLE"=> {
        :name=>"GREGVILLE",
        :generic_csv_data_2=> {
          "Math"=>{2010=>0.11, 2011=>0.21, 2012=>0.31},
          "Reading"=>{2010=>0.115, 2011=>0.215, 2012=>0.315}
        }
      },
      "ASHLEYVILLE"=> {
        :name=>"ASHLEYVILLE",
        :generic_csv_data_2=> {
          "Math"=>{2010=>0.41, 2011=>0.51, 2012=>0.61},
          "Reading"=>{2010=>0.415, 2011=>0.515, 2012=>0.615}
        }
      }
    }

    assert_equal expected_data, elh.districts_hashes[:enrollment]
  end

  def test_extract_data_from_multiple_csvs
    elh = setup
    csv_1 = generic_csv_file(1)
    csv_2 = generic_csv_file(2)

    elh.create_districts_hashes(:enrollment, csv_1)
    elh.create_districts_hashes(:enrollment, csv_2)
    elh.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_1, csv_1)
    elh.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_2, csv_2)

    binding.pry

    expected_data = {
      "GREGVILLE"=> {
        :name=>"GREGVILLE",
        :generic_csv_data_2=> {
          "Math"=>{2010=>0.11, 2011=>0.21, 2012=>0.31},
          "Reading"=>{2010=>0.115, 2011=>0.215, 2012=>0.315}
        }
      },
      "ASHLEYVILLE"=> {
        :name=>"ASHLEYVILLE",
        :generic_csv_data_2=> {
          "Math"=>{2010=>0.41, 2011=>0.51, 2012=>0.61},
          "Reading"=>{2010=>0.415, 2011=>0.515, 2012=>0.615}
        }
      }
    }

    assert_equal expected_data, elh.districts_hashes[:enrollment]
  end




  def setup_with_generic_csv_file(n)
    elh = setup
    [elh, elh.extract_csv(generic_csv_file(n))]
  end

  def small_data_set
    {
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarteners-enrollment-sample.csv",
      },
      :statewide_generic_csv_data_2 => {
        :third_grade => third_grade_sample,
      },
      :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
      }
    }
  end

  def big_data_set
    {
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarteners-enrollment-sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv",
      },
      :statewide_generic_csv_data_2 => {
        :third_grade => "./test/fixtures/third_grade_statewidetest_sample.csv",
        :eighth_grade => "./test/fixtures/eighth_grade_statewidetest_sample.csv",
      },
      :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
        :title_1 => "./test/fixtures/title_1_economicprofile_sample.csv"
      }
    }
  end

  def third_grade_sample
    "./test/fixtures/third_grade_statewidetest_sample.csv"
  end

  def generic_csv_file(n)
    "./test/fixtures/csv_extractor_#{n}.csv"
  end

end