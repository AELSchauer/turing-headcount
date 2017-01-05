require './lib/schema'
require 'pry'

class Enrollment < Schema

  def initialize(info_hash)
    super(info_hash)
  end

end