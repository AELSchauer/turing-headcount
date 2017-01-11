require 'pry'
require './lib/data_scheme'

class StatewideTest < DataScheme

  attr_reader :grades,
              :subjects,
              :races

  def initialize(info_hash)
    super(info_hash)
    @grades = {3=>:third_grade, 8=>:eighth_grade}
    @subjects = [:math, :reading, :writing]
    @races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def proficient_by_grade(grade)
    unknown_error_handler(@grades.keys, grade, :grade)
    rearrange_grade_data(@grades[grade])
  end

  def proficient_by_race_or_ethnicity(race)
    unknown_error_handler(@races, race, :race)
    rearrange_race_data(race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    unknown_error_handler(@subjects, subject, :subject)
    proficiency_zero?(proficient_by_grade(grade)[year][subject])
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    unknown_error_handler(@subjects, subject, :subject)
    proficiency_zero?(proficient_by_race_or_ethnicity(race)[year][subject])
  end

  def proficient_for_subject_by_grade(subject, grade)
    unknown_error_handler(@grades.keys, grade, :grade)
    unknown_error_handler(@subjects, subject, :subject)
    @data[@grades[grade]][subject]
  end

  def proficient_for_subject_by_race(subject, race)
    unknown_error_handler(@races, race, :race)
    unknown_error_handler(@subjects, subject, :subject)
    @data[subject][race]
  end

  def unknown_error_handler(reference_array, category_element, category_name)
    insufficient_error_handler(category_element, category_name)
    unless reference_array.include?(category_element)
      error_message = "#{category_element} is not a known #{category_name.to_s}"
      error_type = category_name == :race ? UnknownRaceError : UnknownDataError
      raise error_type, error_message
    end
  end

  def insufficient_error_handler(category_element, category_name)
    if category_element.nil?
      error_message = "A #{category_name.to_s} must be provided to answer this question"
      raise InsufficientInformationError, error_message
    end
  end

  def proficiency_zero?(proficiency)
    proficiency == 0.0 ? "N/A" : proficiency
  end

  def rearrange_grade_data(grade)
    years = @data[grade].values[0].keys
    rearrange_hashes(years, grade, :grade)
  end

  def rearrange_race_data(race)
    years = @data[:math].values[0].keys.sort
    rearrange_hashes(years, race, :race)
  end

  def rearrange_hashes(years, category_element, category_name)
    years.reduce({}) do |year_subject_data, year|
      subject_data = @subjects.reduce({}) do |subject_data, subject|
        data = data_path(category_element, subject, year, category_name)
        subject_data.merge({subject => data})
      end
      year_subject_data.merge!({year => subject_data})
    end
  end

  def data_path(category_element, subject, year, category_name)
    if category_name == :race
      @data[subject][category_element][year]
    elsif category_name == :grade
      @data[category_element][subject][year]
    end
  end

  def average_percentage_growth(weights, grade, subject_list)
    subject_proficiency_list = subject_proficiency_list(weights, grade, subject_list)
    return nil if subject_proficiency_list.nil?
    subject_proficiency_list / subject_list.count
  end

  def subject_proficiency_list(weights, grade, subject_list)
    subject_list.reduce(0) do |sum, subject|
      subject_average = calculate_subject_proficiency(weights[subject], grade, subject)
      return nil if subject_average.nil?
      sum += subject_average
    end
  end

  def calculate_subject_proficiency(weight, grade, subject)
    year_min, year_max = subject_grade_data(grade, subject).keys.minmax
    return nil if year_min == year_max
    year_min_proficiency = proficient_for_subject_by_grade_in_year(subject, grade, year_min)
    year_max_proficiency = proficient_for_subject_by_grade_in_year(subject, grade, year_max)
    (year_max_proficiency - year_min_proficiency) / (year_max - year_min) * weight * 3
  end

  def subject_grade_data(grade, subject)
     keep_only_years_with_data(proficient_for_subject_by_grade(subject, grade))
  end

  def keep_only_years_with_data(year_data_hash)
    year_data_hash.find_all { |(year, data)| data != 0.0 }.to_h
  end

end