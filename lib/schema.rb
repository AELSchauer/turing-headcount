require 'pry'

class Schema

  attr_reader :name,
              :data

  def initialize(info_hash)
    extract_information(info_hash)
  end

  def extract_information(info_hash)
    @name = info_hash[:name].upcase
    @data = info_hash.dup
    @data.delete(:name)
    nil
  end

  def add_datasets(new_data)
    @data.merge!(new_data)
  end

end


# This was the template I used to understand how inheritance works with classes and subclasses. Disregard this.
# To better understand this, go to the "operations" project.
# class Schema

#   attr_accessor :input_a,
#                 :input_b

#   def initialize(input_a = 0, input_b = 0)
#     @input_a = input_a
#     @input_b = input_b
#   end

#   def output
#     if input_a == 0
#       0
#     elsif input_b == 0
#       0
#     else
#       1
#     end
#   end

# end