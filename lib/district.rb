require 'pry'
require './lib/data_scheme'

class District < DataScheme

  def initialize(info_hash)
    super(info_hash)
  end

  def create_connection(repository_type, data_scheme_object)
    @data.merge!({repository_type => data_scheme_object})
  end

  def enrollment
    @data[:enrollment]
  end

  def economic_profile
    @data[:economic_profile]
  end

  def statewide_test
    @data[:statewide_test]
  end

end