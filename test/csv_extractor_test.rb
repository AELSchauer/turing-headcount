require './lib/csv_extractor'

require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

class CSVExtractorTest < Minitest::Test

  # def test_load
  #   file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
  #   csv = CSVExtractor.new(file_path)

  #   assert_equal :location,   csv.headers[0]
  #   assert_equal :timeframe,  csv.headers[1]
  #   assert_equal :dataformat, csv.headers[2]
  #   assert_equal :data,       csv.headers[3]
  #   assert_equal "Colorado",  csv.contents[0][:location]
  #   assert_equal "2010",      csv.contents[0][:timeframe]
  #   assert_equal "Percent",   csv.contents[0][:dataformat]
  #   assert_equal "0.724",     csv.contents[0][:data]
  # end

  # def test_district_list
  #   file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
  #   csv = CSVExtractor.new(file_path)
  #   districts = ["Colorado", "ASHLEYVILLE", "GREGVILLE"]

  #   assert_equal districts, csv.district_list
  # end

  # def test_data_hash
  #   file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
  #   csv = CSVExtractor.new(file_path)
  #   data = {
  #     "COLORADO" =>    {"2010"=>"0.724", "2011"=>"0.739", "2012"=>"0.75354", "2013"=>"0.769", "2014"=>"0.773"},
  #     "ASHLEYVILLE" => {"2010"=>"0.895", "2011"=>"0.895", "2012"=>"0.88983", "2013"=>"0.91373", "2014"=>"0.898"},
  #     "GREGVILLE" =>   {"2010"=>"0.57", "2011"=>"0.608", "2012"=>"0.63372", "2013"=>"0.59351", "2014"=>"0.659"}
  #   }

  #   assert_equal data, csv.data_hash
  # end

  # def test_read_file
  #   extractor = CSVExtractor.new

  #   file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
  #   table = extractor.read_file(file_path)

  #   binding.pry
  #   assert_equal Table, table.class
  #   assert_equal 15,    table.length
  # end

  # def test_specify_data_categories
  #   extractor = CSVExtractor.new

  #   file_path = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
  #   table = extractor.read_file(file_path)
  #   extractor.specify_data_categories(table, :enrollment, :high_school_graduation)

  # end

  # def test_combine_all_tables
  #   extractor = CSVExtractor.new
  #   file_path_1 = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
  #   file_path_2 = "./test/fixtures/kindergarteners-enrollment-sample.csv"
  #   table_1 = extractor.read_file(file_path_1)
  #   table_2 = extractor.read_file(file_path_2)

  #   extractor.specify_data_categories(table_1, :enrollment, :high_school_graduation)
  #   extractor.specify_data_categories(table_2, :enrollment, :kindergarten)

  #   extractor.combine_all_tables

  # end

  def test_convert_main_table_to_hash
    extractor = CSVExtractor.new
    file_path_1 = "./test/fixtures/high_school_graduation_enrollment_sample.csv"
    file_path_2 = "./test/fixtures/kindergarteners-enrollment-sample.csv"
    table_1 = extractor.read_file(file_path_1)
    table_2 = extractor.read_file(file_path_2)

    extractor.specify_data_categories(table_1, :enrollment, :high_school_graduation)
    extractor.specify_data_categories(table_2, :enrollment, :kindergarten)

    formatted_hash = extractor.convert_main_table_to_hash
  end

  # def test_pair_dataset_name_with_data
  #   extractor = CSVExtractor.new
  #   dataset_name = high_school_graduation.keys.first
  #   file_path = high_school_graduation.values.first
  #   data_hash = extractor.insert_middle_hash_level(dataset_name, file_path)
  # end

  # def test_merge_siblings
  #   extractor = CSVExtractor.new
  #   data_hash = extractor.merge_siblings(hs_and_kindergarten)
  # end

  # def test_load_data_small
  #   extractor = CSVExtractor.new
  #   data_hash = extractor.load_data(small_enrollment)
  # end

  # def test_load_data_small_two_repos
  #   extractor = CSVExtractor.new
  #   data_hash = extractor.load_data(two_small_repositories)
  # end

  def high_school_graduation
    {
      :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
    }
  end

  def hs_and_kindergarten
    {
        :kindergarten => "./test/fixtures/kindergarteners-enrollment-sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
      }
  end

  def small_enrollment
    { :enrollment => {
        :kindergarten => "./test/fixtures/kindergarteners-enrollment-sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
      }
    }
  end

  def small_statewide_testing
    { :statewide_testing => {
        :third_grade => "./test/fixtures/third_grade_statewidetest_sample.csv",
      }
    }
  end

  def two_small_repositories
    { :enrollment => {
        :kindergarten => "./test/fixtures/kindergarteners-enrollment-sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
      },
      :statewide_testing => {
        :third_grade => "./test/fixtures/third_grade_statewidetest_sample.csv",
        :eighth_grade => "./test/fixtures/eighth_grade_statewidetest_sample.csv",
      }
    }
  end

  def small_economic_profile
    { :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
      }
    }
  end

  def all_csv_files
    { :enrollment => {
        :kindergarten => "./data/Kindergarteners-enrollment in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    }
  end

end