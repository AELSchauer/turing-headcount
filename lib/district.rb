require './lib/schema'
require 'pry'

class District < Schema

  def initialize(info_hash)
    super(info_hash)
  end

  def create_connection(category, object)
    @data[category] = object
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

# This was the template I used to understand how inheritance works with classes and subclasses. Disregard this.
# To better understand this, go to the "operations" project.
# class District < Schema

#   def output
#     gate = Schema.new(@input_a, @input_b)
#     gate.output
#   end

# end