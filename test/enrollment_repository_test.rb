require 'simplecov'
SimpleCov.start

require './lib/enrollment_repository'

require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

class EnrollmentRepositoryTest < Minitest::Test

  def test_create
    er = EnrollmentRepository.new

    assert_equal Hash.new, er.data_links
    assert_equal Hash.new, er.repo_links
  end

  def test_load_data_both_enrollments
    er = EnrollmentRepository.new

    er.load_data(both_enrollments)

    assert_equal 3,             er.data_links.length
    assert_equal "COLORADO",    er.data_links["COLORADO"].name
    assert_equal "ASHLEYVILLE", er.data_links["ASHLEYVILLE"].name
    assert_equal "GREGVILLE",   er.data_links["GREGVILLE"].name
  end

  def test_load_data_both_enrollments_separately
    er_1 = EnrollmentRepository.new
    er_2 = EnrollmentRepository.new

    er_1.load_data(both_enrollments)
    er_2.load_data(kindergarten)
    er_2.load_data(high_school_graduation)

    assert_equal er_1.data_links.length,              er_2.data_links.length
    assert_equal er_1.data_links["COLORADO"].data,    er_2.data_links["COLORADO"].data
    assert_equal er_1.data_links["ASHLEYVILLE"].data, er_2.data_links["ASHLEYVILLE"].data
    assert_equal er_1.data_links["GREGVILLE"].data,   er_2.data_links["GREGVILLE"].data
  end

  # def test_load_data_small_multiple
  #   er = EnrollmentRepository.new

  #   er.load_data(small_enrollment)
  #   er.load_data(small_statewide_testing)
  #   er.load_data(small_economic_profile)

  #   assert_equal 3,             er.data_links.length
  #   assert_equal "COLORADO",    er.data_links["COLORADO"].name
  #   assert_equal "ASHLEYVILLE", er.data_links["ASHLEYVILLE"].name
  #   assert_equal "GREGVILLE",   er.data_links["GREGVILLE"].name
  # end

  # def test_load_data_full
  #   er = EnrollmentRepository.new

  #   er.load_data(all_csv_files)

  #   assert_equal 181, er.data_links.length
  # end

  def kindergarten
    { :enrollment => {
        :kindergarten => "./test/fixtures/third_grade_statewidetest_sample.csv",
      }
    }
  end

  def high_school_graduation
    { :enrollment => {
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
      }
    }
  end

  def both_enrollments
    { :enrollment => {
        :kindergarten => "./test/fixtures/third_grade_statewidetest_sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
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
        :chileren_in_poverty => "./data/School-aged chileren in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    }
  end

end