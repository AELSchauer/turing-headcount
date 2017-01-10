require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

class CSVFiles

  def small_enrollment
    { :enrollment => {
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv"
      }
    }
  end

  def small_statewide_testing
    { :statewide_test => {
        :third_grade => CSVFiles.third_grade_sample,
      }
    }
  end

  def small_economic_profile
    { :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
      }
    }
  end

  def self.all_csv_files
    { :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      },
      :statewide_test => {
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

  def self.a_few_csv_files
    { :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      },
      :statewide_test => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
      }
    }
  end

  def self.small_data_set
    {
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarteners_enrollment_sample.csv",
      },
      :statewide_test => {
        :third_grade => CSVFiles.third_grade_sample
      },
      :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
      }
    }
  end

  def self.big_data_set
    {
      :enrollment => {
        :kindergarten => "./test/fixtures/kindergarteners_enrollment_sample.csv",
        :high_school_graduation => "./test/fixtures/high_school_graduation_enrollment_sample.csv",
      },
      :statewide_test => {
        :third_grade => CSVFiles.third_grade_sample,
        :eighth_grade => "./test/fixtures/eighth_grade_statewidetest_sample.csv",
      },
      :economic_profile => {
        :median_household_income => "./test/fixtures/median_household_income_economicprofile_sample.csv",
        :title_1 => "./test/fixtures/title_1_economicprofile_sample.csv"
      }
    }
  end

  def self.third_grade_sample
    "./test/fixtures/third_grade_statewidetest_sample.csv"
  end

  def self.generic_csv_file(n)
    "./test/fixtures/csv_extractor_#{n}.csv"
  end

end