require 'pry'
require './lib/data_scheme'

class Enrollment < DataScheme

  def initialize(info_hash)
    super(info_hash)
  end

  def kindergarten_participation_by_year
    @data[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    @data[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end

end