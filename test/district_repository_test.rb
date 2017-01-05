require './lib/district_repository'

require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

class DistrictRepositoryTest < Minitest::Test

  def test_create
    dr = DistrictRepository.new

    assert_equal Hash.new, dr.data_links
    assert_equal Hash.new, dr.repo_links
  end

  def test_load_data_small_single
    dr = DistrictRepository.new

    dr.load_data(small_enrollment)

    assert_equal 3,             dr.data_links.length
    assert_equal "COLORADO",    dr.data_links["COLORADO"].name
    assert_equal "ASHLEYVILLE", dr.data_links["ASHLEYVILLE"].name
    assert_equal "GREGVILLE",   dr.data_links["GREGVILLE"].name
  end

  def test_load_data_small_multiple
    dr = DistrictRepository.new

    dr.load_data(small_enrollment)
    dr.load_data(small_statewide_testing)
    dr.load_data(small_economic_profile)

    assert_equal 3,             dr.data_links.length
    assert_equal "COLORADO",    dr.data_links["COLORADO"].name
    assert_equal "ASHLEYVILLE", dr.data_links["ASHLEYVILLE"].name
    assert_equal "GREGVILLE",   dr.data_links["GREGVILLE"].name
  end

  def test_load_data_full
    dr = DistrictRepository.new

    dr.load_data(all_csv_files)

    assert_equal 181, dr.data_links.length
  end

  def small_enrollment
    { :enrollment => {
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

  def small_economic_profile
    { :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
      }
    }
  end

  def all_csv_files
    { :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
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