require 'pry'
require './lib/data_scheme'

class StatewideTest < DataScheme

  def initialize(info_hash)
    super(info_hash)
    @grades = {
        :third_grade => 3,
        :eighth_grade => 8
      }
    @subjects = [:math, :reading, :writing]
    @races = {
        "Asian" => :asian,
        "Black" => :black,
        "Hawaiian/Pacific Islander" => :pacific_islander,
        "Hispanic" => :hispanic,
        "Native American" => :native_american,
        "Two or more" => :two_or_more,
        "White" => :white
      }
  end

  def proficient_by_grade(grade)
    rearrange_grade_data[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    rearrange_race_data[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    proficient_by_grade(grade)[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    proficient_by_race_or_ethnicity(race)[year][subject]
  end

  def rearrange_grade_data
    grades = @grades.keys.sort
    subjects = @data[grades[0]].keys.sort
    years = @data[grades[0]][subjects[0]].keys.sort
    rearrange_hashes(@grades, grades, years, subjects)
  end

  def rearrange_race_data
    races = @races.keys.sort
    years = @data[@subjects[0]][races[0]].keys.sort
    rearrange_hashes(@races, races, years, @subjects)
  end

  def rearrange_hashes(master_category, categories, years, subjects)
    categories.reduce({}) do |category_years, category|
      year_subjects = years.reduce({}) do |year_subjects, year|
        subjects_data = subjects.reduce({}) do |subjects_data, subject|
          data = data_path(master_category, category, subject, year)
          subjects_data.merge!({subject.downcase.to_sym => data})
        end
        year_subjects.merge!({year => subjects_data})
      end
      category_years.merge!({master_category[category] => year_subjects})
    end
  end

  def data_path(master_category, category, subject, year)
    if master_category == @races
      @data[subject][category][year]
    elsif master_category == @grades
      @data[category][subject][year]
    end
  end

end