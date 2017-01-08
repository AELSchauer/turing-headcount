require 'pry'
require './lib/repository'
require './lib/statewide_test'

class StatewideTestRepository < Repository

  def initialize
    super
    @repository_type = :statewide_testing
    @data_class = StatewideTest
  end

end