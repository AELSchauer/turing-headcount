require 'pry'
require './lib/exceptions'

class HeadcountAnalyst
  include Exceptions

  attr_reader :district_repository,
              :state_name,
              :default_weights,
              :subjects

  def initialize(district_repository)
    @district_repository = district_repository
    @state_name = "COLORADO"
    @default_weights = {:math=>(1.0/3.0), :reading=>(1.0/3.0), :writing=>(1.0/3.0)}
    @subjects = [:math, :reading, :writing]
  end

  def top_statewide_test_year_over_year_growth(input_args)
    subject_list, weights, top = check_default_values(input_args[:subject], input_args[:weighting], input_args[:top])
    district_total_growth_list = total_growth_averages_for_all_districts(weights, input_args[:grade], subject_list)
    top_districts(district_total_growth_list, top)
  end

  def top_districts(growth_list, n)
    top_growth_list = growth_list.values.sort.reverse[0..n-1]
    if n == 1
      top_growth = top_growth_list.first
      retrieve_districts_by_proficiency(growth_list, top_growth)
    else
      top_growth_list.reduce([]) do |top_n_growth_districts, top_growth|
        nth_top_districts = retrieve_districts_by_proficiency(growth_list, top_growth)
        top_n_growth_districts.push(nth_top_districts)
      end
    end
  end

  def retrieve_districts_by_proficiency(growth_list, top_growth)
    district_list = growth_list.reduce([]) do |district_list, (district_name, growth)|
      district_list.push(district_name) if growth == top_growth
      district_list
    end
    district_list = district_list.length == 1 ? district_list.first : district_list
    [district_list, top_growth]
  end

  def conflicting_input_arguments_error_check(subject, weights)
    if not(subject.nil? or weights.nil?)
      raise ConflictingArgumentsError, "subject and weighting are mutually exclusive arguments"
    end
  end

  def check_default_values(subject, weights, top)
    conflicting_input_arguments_error_check(subject, weights)
    subject_list = subject.nil? ? @subjects        : [subject]
    weights      = weights.nil? ? @default_weights : weights
    top          = top.nil?     ? 1                : top
    weights_insufficient_error_check(weights.values)
    [subject_list, weights, top]
  end

  def weights_insufficient_error_check(weights)
    error_message = "weights provided do not sum to 1.0"
    raise(InsufficientInformationError, error_message) unless weights_sum_to_one?(weights)
  end

  def weights_sum_to_one?(weights)
    1.0 == weights.reduce(0) { |sum, weight| sum += weight }.round(3)
  end

  def total_growth_averages_for_all_districts(weights, grade, subject_list)
    statewide_test_list = get_statewide_test_list
    statewide_test_list.reduce({}) do |total_growth_list, (district_name, statewide_test)|
      growth = statewide_test.average_percentage_growth(weights, grade, subject_list)
      unless growth.nil?
        total_growth_list.merge!({district_name => growth})
      end
      total_growth_list
    end
  end

  def get_statewide_test_list
    @district_repository.statewide_test_repository.data_scheme_links(include_state: false)
  end







  def kindergarten_participation_rate_variation(district_a_name, comparison_hash)
    enrollment_participation_rate_variation(district_a_name, comparison_hash[:against], :kindergarten)
  end

  def kindergarten_participation_rate_variation_trend(district_a_name, comparison_hash)
    enrollment_participation_rate_variation_trend(district_a_name, comparison_hash[:against], :kindergarten)
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    kindergarten_variation = enrollment_participation_rate_variation(district_name, @state_name, :kindergarten)
    hs_graduation_variation = enrollment_participation_rate_variation(district_name, @state_name, :high_school_graduation)
    format_number(kindergarten_variation / hs_graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(input_hash)
    districts_list = correlation_districts_list(input_hash.values[0])
    variations = variation_per_district(districts_list)
    correlation = percent_within_bounds(variations)
    correlation > 0.7
  end

  def variation_per_district(districts_list)
    variation_list = districts_list.map() do |district_name|
      variation = kindergarten_participation_against_high_school_graduation(district_name)
      variation.nan? ? 0.0 : variation
    end
  end

  def correlation_districts_list(input)
    if input == "STATEWIDE"
      @district_repository.get_district_list(include_state: false)
    elsif input.class == Array
      input
    else
      [input]
    end
  end

  def percent_within_bounds(variations)
    (variations.reduce(0) { |sum, number| sum += within_bounds(number) } / variations.count.to_f).round(3)
  end

  def within_bounds(number)
    number > 0.6 && number < 1.5 ? 1.0 : 0.0
  end

  def enrollment_participation_rate_variation(district_a_name, district_b_name, dataset_name)
    enrollment_a = get_district_data(district_a_name, :enrollment, dataset_name)
    enrollment_b = get_district_data(district_b_name, :enrollment, dataset_name)
    years = map_data_for_years(enrollment_a, enrollment_b)
    total_variance_for_years(years, enrollment_a, enrollment_b)
  end

  def enrollment_participation_rate_variation_trend(district_a_name, district_b_name, dataset_name)
    enrollment_a = get_district_data(district_a_name, :enrollment, :kindergarten)
    enrollment_b = get_district_data(district_b_name, :enrollment, :kindergarten)
    years = map_data_for_years(enrollment_a, enrollment_b)
    variance_for_years(years, enrollment_a, enrollment_b)
  end

  def get_district_data(district_name, repository_type, dataset_name)
    district = district_repository.find_by_name(district_name)
    dataset = district[repository_type][dataset_name]
    dataset
  end

  def map_data_for_years(kindergarten_a, kindergarten_b)
    kindergarten_a.keys.sort.reduce([]) do |years, (year, data)|
      if kindergarten_b.keys.include?(year)
        years.push(year)
      end
      years
    end
  end

  def variance_for_years(years, numerator, denominator)
    years.reduce({}) { |variance, year| variance.merge!({ year => format_number(numerator[year]/denominator[year]) }) }
  end

  def format_number(number)
    if number.class == Float
      number.round(3)
    else
      number
    end
  end

  def total_variance_for_years(years, numerator, denominator)
    format_number(sum_for_years(years, numerator) / sum_for_years(years, denominator))
  end

  def sum_for_years(years, data)
    years.reduce(0) { |sum, year| sum += data[year] }
  end

  def map_year_data_by_format(dataset, desired_dataformat) ### Use this method to first get the data in {year => data} format if dataformat was included
    dataset.reduce({}) { |desired_data, (year, data)| desired_data.merge!({year => data[desired_dataformat]}) }
  end

end