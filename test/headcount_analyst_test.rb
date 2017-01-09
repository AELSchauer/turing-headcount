require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

require './lib/headcount_analyst'
require './lib/district_repository'
require './test/test_helper'

class HeadcountAnalystTest < Minitest::Test

  def test_create
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)

    assert_equal HeadcountAnalyst,   ha.class
    assert_equal DistrictRepository, ha.district_repository.class
  end

  def test_kindergarten_participation_rate_variation_sample_data
    dr, ha = setup_small_data_set

    averages = ha.kindergarten_participation_rate_variation('GREGVILLE', :against => 'COLORADO')

    assert_equal 0.766, averages
  end

  def test_kindergarten_participation_rate_variation_actual_data
    dr, ha = setup_a_few_csv_files

    state_averages = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    district_averages = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')

    assert_equal 0.766, state_averages
    assert_equal 0.573, district_averages
  end

  def test_kindergarten_participation_rate_variation_trend_sample_data
    dr, ha = setup_small_data_set

    variance = ha.kindergarten_participation_rate_variation_trend('GREGVILLE', :against => 'COLORADO')
    expected_variance = {
        2004 => 1.258, 2005 => 0.96,
        2006 => 1.05,  2007 => 0.992,
        2008 => 0.718, 2009 => 0.652,
        2010 => 0.681, 2011 => 0.728,
        2012 => 0.689, 2013 => 0.694,
        2014 => 0.661
      }

    assert_equal expected_variance, variance
  end

  def test_kindergarten_participation_rate_variation_trend_actual_data
    dr, ha = setup_a_few_csv_files

    state_variance = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    district_variance = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'ADAMS COUNTY 14')

    expected_state_variance = {
        2004 => 1.258, 2005 => 0.96,
        2006 => 1.05,  2007 => 0.992,
        2008 => 0.718, 2009 => 0.652,
        2010 => 0.681, 2011 => 0.728,
        2012 => 0.689, 2013 => 0.694,
        2014 => 0.661
      }

    expected_district_variance = {
        2004 => 1.325, 2005 => 0.89,
        2006 => 1.208, 2007 => 1.281,
        2008 => 0.572, 2009 => 0.39,
        2010 => 0.436, 2011 => 0.489,
        2012 => 0.479, 2013 => 0.489,
        2014 => 0.49
      }

    assert_equal expected_state_variance,    state_variance
    assert_equal expected_district_variance, district_variance
  end

  def setup
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    [dr, ha]
  end

  def setup_small_data_set
    dr, ha = setup
    dr.load_data(CSVFiles.small_data_set)
    [dr, ha]
  end

  def setup_all_csv_files
    dr, ha = setup
    dr.load_data(CSVFiles.all_csv_files)
    [dr, ha]
  end

  def setup_a_few_csv_files
    dr, ha = setup
    dr.load_data(CSVFiles.a_few_csv_files)
    [dr, ha]
  end

end