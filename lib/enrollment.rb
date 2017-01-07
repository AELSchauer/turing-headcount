require './lib/schema'
require 'pry'

class Enrollment < Schema

  def initialize(info_hash)
    super(info_hash)
  end

  def kindergarten_participation_by_year
    @data[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

end