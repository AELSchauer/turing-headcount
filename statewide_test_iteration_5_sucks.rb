require 'pry'
require './lib/data_scheme'

class StatewideTest < DataScheme

  def initialize(info_hash)
    super(info_hash)
    @grades = {:third_grade=>3, :eighth_grade=>8}
    @subjects = [:math, :reading, :writing]
    @races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
  end

  def proficient_by_grade(grade)
    data_error_handler(@grades.values, grade, :grade)
    rearrange_grade_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    race_error_handler(@races, race, :race)
    rearrange_race_data[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year, zero=true)
    data_error_handler(@subjects, subject, :subject)
    proficiency = proficient_by_grade(grade)[year][subject]
    zero ? proficiency_zero?(proficiency) : proficiency
  end

  def proficient_for_subject_by_race_in_year(subject, race, year, zero=true)
    data_error_handler(@subjects, subject, :subject)
    proficiency = proficient_by_race_or_ethnicity(race)[year][subject]
    zero ? proficiency_zero?(proficiency) : proficiency
  end

  def insufficient_error_handler(element, category)
    raise(InsufficientInformationError, "A #{category.to_s} must be provided to answer this question") if element.nil?
  end

  def data_error_handler(reference_array, element, category)
    insufficient_error_handler(element, category)
    raise(UnknownDataError, "#{element} is not a known #{category.to_s}") unless reference_array.include?(element)
  end

  def race_error_handler(reference_array, element, category)
    insufficient_error_handler(element, category)
    raise(UnknownRaceError, "#{element} is not a known #{category.to_s}") unless reference_array.include?(element)
  end

  def proficiency_zero?(proficiency)
    proficiency == 0.0 ? "N/A" : proficiency
  end

  def rearrange_grade_data
    grades = @grades.keys.sort
    subjects = @data[grades[0]].keys.sort
    years = @data[grades[0]][subjects[0]].keys.sort
    rearrange_hashes(grades, years, subjects, @grades)
  end

  def rearrange_race_data
    races = @races.sort
    years = @data[@subjects[0]][races[0]].keys.sort
    rearrange_hashes(races, years, @subjects)
  end

  def rearrange_hashes(categories, years, subjects, master_category=nil)
    categories.reduce({}) do |category_years, category|
      year_subjects = years.reduce({}) do |year_subjects, year|
        subjects_data = subjects.reduce({}) do |subjects_data, subject|
          data = data_path(category, subject, year, master_category)
          subjects_data.merge!({subject.downcase.to_sym => data})
        end
        year_subjects.merge!({year => subjects_data})
      end
      key = category_key(master_category, category)
      category_years.merge!({key => year_subjects})
    end
  end

  def data_path(category, subject, year, master_category)
    master_category.nil? ? @data[subject][category][year] : @data[category][subject][year]
  end

  def category_key(master_category, category)
    master_category.nil? ? category : master_category[category]
  end

  def delete_years_without_data(year_data_hash)
    year_data_hash.find_all { |(year, data)| data != 0.0 }.to_h
  end

  def proficient_for_subject_by_grade(grade, subject)
    grade_name = @grades.find { |dataset_name, data| data == grade }[0]
    @data[grade_name][subject]
  end

  def average_percentage_growth(grade, subject)
    subject_list = subject.nil? ? @subjects : [subject]
    subject_list.reduce({}) do |subject_proficiency, subject|
      subject_average = calculate_subject_proficiency(grade, subject)
      subject_proficiency.merge!({subject => subject_average})
    end
  end

  def subject_grade_data(grade, subject)
     delete_years_without_data(proficient_for_subject_by_grade(grade, subject))
  end

  def calculate_subject_proficiency(grade, subject)
    year_min, year_max = subject_grade_data(grade, subject).keys.minmax
    year_min_proficiency = proficient_for_subject_by_grade_in_year(subject, grade, year_min, false)
    year_max_proficiency = proficient_for_subject_by_grade_in_year(subject, grade, year_max, false)
    subject_average = ((year_max_proficiency - year_min_proficiency) / (year_max - year_min))
  end

  def calculate_average_percentage_growth(subject_proficiency, weights={:math=>(1/3), :reading=>(1/3), :writing=>(1/3)})
    @subjects.reduce(0) do |sum, subject|
      subject_proficiency[subject] * (weights[subject] * 3.0)
    end
    (sum / @subjects.count).round(3)
  end

end