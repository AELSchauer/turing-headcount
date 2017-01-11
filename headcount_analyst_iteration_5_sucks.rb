require 'pry'
require './lib/exceptions'

class HeadcountAnalyst
  include Exceptions

  attr_reader :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
    @state_name = "COLORADO"
  end

  def top_statewide_test_year_over_year_growth(input_hash)
    district_proficiencies = get_proficiencies_for_all_districts(input_hash)
    grouped_proficiencies = district_proficiencies.group_by { |(district_name, proficiency)| proficiency }
    n = input_hash[:top].nil? ? 1 : input_hash[:top]
    max_n_proficiencies = grouped_proficiencies.keys.sort.max(top)
    binding.pry
    districts = max_n_proficiencies
  end

  def get_proficiencies_for_all_districts(input_hash)
    grade = input_hash[:grade]
    subject = input_hash[:subject]
    all_districts = @district_repository.get_district_list(include_state: false)
    all_districts.reduce({}) do |proficiencies, district_name|
      stw = @district_repository.find_by_name(district_name).statewide_test
      growth = stw.average_percentage_growth(grade, subject)
      proficiencies.merge!({district_name => growth})
    end
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

  def map_year_data_by_format(dataset, desired_dataformat)
    dataset.reduce({}) { |desired_data, (year, data)| desired_data.merge!({year => data[desired_dataformat]}) }
  end

end