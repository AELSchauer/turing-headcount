require './test/test_helper'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/exceptions'

class HeadcountAnalystTest < Minitest::Test

  # def test_create
  #   dr = DistrictRepository.new
  #   ha = HeadcountAnalyst.new(dr)

  #   assert_equal HeadcountAnalyst,   ha.class
  #   assert_equal DistrictRepository, ha.district_repository.class
  # end

  # def test_kindergarten_participation_rate_variation_sample_data
  #   dr, ha = setup_small_data_set

  #   averages = ha.kindergarten_participation_rate_variation('GREGVILLE', :against => 'COLORADO')

  #   assert_equal 0.766, averages
  # end

  # def test_kindergarten_participation_rate_variation_actual_data
  #   dr, ha = setup_a_few_csv_files

  #   state_averages = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
  #   district_averages = ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'ADAMS COUNTY 14')

  #   assert_equal 0.766, state_averages
  #   assert_equal 0.573, district_averages
  # end

  # def test_kindergarten_participation_rate_variation_trend_sample_data
  #   dr, ha = setup_small_data_set

  #   variance = ha.kindergarten_participation_rate_variation_trend('GREGVILLE', :against => 'COLORADO')
  #   expected_variance = {
  #       2004 => 1.258, 2005 => 0.96,
  #       2006 => 1.05,  2007 => 0.992,
  #       2008 => 0.718, 2009 => 0.652,
  #       2010 => 0.681, 2011 => 0.728,
  #       2012 => 0.689, 2013 => 0.694,
  #       2014 => 0.661
  #     }

  #   assert_equal expected_variance, variance
  # end

  # def test_kindergarten_participation_rate_variation_trend_actual_data
  #   dr, ha = setup_a_few_csv_files

  #   state_variance = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  #   district_variance = ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'ADAMS COUNTY 14')

  #   expected_state_variance = {
  #       2004 => 1.258, 2005 => 0.96,
  #       2006 => 1.05,  2007 => 0.992,
  #       2008 => 0.718, 2009 => 0.652,
  #       2010 => 0.681, 2011 => 0.728,
  #       2012 => 0.689, 2013 => 0.694,
  #       2014 => 0.661
  #     }

  #   expected_district_variance = {
  #       2004 => 1.325, 2005 => 0.89,
  #       2006 => 1.208, 2007 => 1.281,
  #       2008 => 0.572, 2009 => 0.39,
  #       2010 => 0.436, 2011 => 0.489,
  #       2012 => 0.479, 2013 => 0.489,
  #       2014 => 0.49
  #     }

  #   assert_equal expected_state_variance,    state_variance
  #   assert_equal expected_district_variance, district_variance
  # end

  # def test_conflicting_input_arguments_error_check
  #   dr, ha = setup

  #   subject = :math
  #   weights = {:math=>(1.0/3.0), :reading=>(1.0/3.0), :writing=>(1.0/3.0)}

  #   assert_nil ha.conflicting_input_arguments(nil, nil)
  #   assert_nil ha.conflicting_input_arguments(subject, nil)
  #   assert_nil ha.conflicting_input_arguments(nil, weights)

  #   assert_raises(Exceptions::ConflictingArgumentsError) do
  #     ha.conflicting_input_arguments(subject, weights)
  #   end
  # end

  # def test_check_default_values
  #   dr, ha = setup

  #   subject = :math
  #   weights = {:math=>(3.0/8.0), :reading=>(3.0/8.0), :writing=>(1.0/4.0)}

  #   expected_default_values_1 = [ha.subjects, ha.default_weights]
  #   expected_default_values_2 = [[subject],   ha.default_weights]
  #   expected_default_values_3 = [ha.subjects, weights]

  #   assert_equal expected_default_values_1, ha.check_default_values(nil, nil)
  #   assert_equal expected_default_values_2, ha.check_default_values(subject, nil)
  #   assert_equal expected_default_values_3, ha.check_default_values(nil, weights)

  #   assert_raises(Exceptions::ConflictingArgumentsError) do
  #     ha.check_default_values(subject, weights)
  #   end
  # end

  def test_weights_sum_to_one
    dr, ha = setup

    weight_numbers_1 = [(1.0/3.0), (1.0/3.0), (1.0/3.0)]
    weight_numbers_2 = [0.375, 0.375, 0.25]
    weight_numbers_3 = [1.0, 0.0, 0.0]
    weight_numbers_4 = [0.0, 0.5, 0.5]
    weight_numbers_5 = [0.3333, 0.3333, 0.3333]

    weight_numbers_6 = [(1.0/6.0), (1.0/3.0), (1.0/3.0)]
    weight_numbers_7 = [0.375, 0.375, 0.15]
    weight_numbers_8 = [1.0, 1.0, 0.0]
    weight_numbers_9 = [0.0, 0.5, 0.0]
    weight_numbers_A = [0.333, 0.333, 0.333]

    assert ha.weights_sum_to_one?(weight_numbers_1)
    assert ha.weights_sum_to_one?(weight_numbers_2)
    assert ha.weights_sum_to_one?(weight_numbers_3)
    assert ha.weights_sum_to_one?(weight_numbers_4)
    assert ha.weights_sum_to_one?(weight_numbers_5)

    refute ha.weights_sum_to_one?(weight_numbers_6)
    refute ha.weights_sum_to_one?(weight_numbers_7)
    refute ha.weights_sum_to_one?(weight_numbers_8)
    refute ha.weights_sum_to_one?(weight_numbers_9)
    refute ha.weights_sum_to_one?(weight_numbers_A)
  end

  def test_weights_insufficient_error_check
    dr, ha = setup

    weight_numbers_1 = [(1.0/3.0), (1.0/3.0), (1.0/3.0)]
    weight_numbers_2 = [0.375, 0.375, 0.25]
    weight_numbers_3 = [1.0, 0.0, 0.0]
    weight_numbers_4 = [0.0, 0.5, 0.5]
    weight_numbers_5 = [0.3333, 0.3333, 0.3333]

    weight_numbers_6 = [(1.0/6.0), (1.0/3.0), (1.0/3.0)]
    weight_numbers_7 = [0.375, 0.375, 0.15]
    weight_numbers_8 = [1.0, 1.0, 0.0]
    weight_numbers_9 = [0.0, 0.5, 0.0]
    weight_numbers_A = [0.333, 0.333, 0.333]

    assert_nil ha.weights_insufficient_error_check(weight_numbers_1)
    assert_nil ha.weights_insufficient_error_check(weight_numbers_2)
    assert_nil ha.weights_insufficient_error_check(weight_numbers_3)
    assert_nil ha.weights_insufficient_error_check(weight_numbers_4)
    assert_nil ha.weights_insufficient_error_check(weight_numbers_5)

    assert_raises(Exceptions::InsufficientInformationError) do
      ha.weights_insufficient_error_check(weight_numbers_6)
    end

    assert_raises(Exceptions::InsufficientInformationError) do
      ha.weights_insufficient_error_check(weight_numbers_7)
    end

    assert_raises(Exceptions::InsufficientInformationError) do
      ha.weights_insufficient_error_check(weight_numbers_8)
    end

    assert_raises(Exceptions::InsufficientInformationError) do
      ha.weights_insufficient_error_check(weight_numbers_9)
    end

    assert_raises(Exceptions::InsufficientInformationError) do
      ha.weights_insufficient_error_check(weight_numbers_A)
    end

  end


  # def test_top_statewide_test_year_over_year_growth
  #   dr, ha = setup_a_few_csv_files

  #   # assert_raises(Exceptions::InsufficientInformationError) do
  #   #   ha.top_statewide_test_year_over_year_growth(subject: :math)
  #   # end

  #   # assert_raises(Exceptions::InsufficientInformationError) do
  #   #   ha.top_statewide_test_year_over_year_growth(grade: 3)
  #   # end

  #   # assert_raises(Exceptions::UnknownDataError) do
  #   #   ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
  #   # end

  #   # assert_raises(Exceptions::UnknownDataError) do
  #   #   ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :history)
  #   # end

  #   ha.top_statewide_test_year_over_year_growth(grade: 3)
  # end

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