require 'pry'
require './lib/repository'
require './lib/economic_profile'

class EconomicProfileRepository < Repository

  def initialize
    super
    @repository_type = :economic_profile
    @data_class = EconomicProfile
  end

end