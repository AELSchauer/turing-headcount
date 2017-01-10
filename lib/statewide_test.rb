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
    raise(UnknownDataError) unless @grades.values.include?(grade)
    rearrange_grade_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    raise(UnknownRaceError) unless @races.include?(race)
     rearrange_race_data[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise(UnknownDataError) unless @subjects.include?(subject)
    proficiency_zero?(proficient_by_grade(grade)[year][subject])
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless @subjects.include?(subject)
    proficiency_zero?(proficient_by_race_or_ethnicity(race)[year][subject])
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

end