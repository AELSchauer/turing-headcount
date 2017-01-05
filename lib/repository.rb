require 'pry'

class Repository

  attr_reader :data_links,
              :repo_links

  def initialize
    @data_links = {}
    @repo_links = {}
  end

  def district_list(load_hash)
    load_hash.map { |repository_name, dataset|
      dataset.map { |dataset_name, file_path|
        CSVExtractor.new(file_path).district_list
      }
    }.flatten.sort.uniq
  end

  # def district_data(load_hash)
  #   load_hash.each do |repository_name, dataset|
  #     dataset.each do |dataset_name, data|
  #       CSVExtractor.new(data).data_hash
  #       binding.pry
  #     end
  #   end
  # end

  def district_data_hash(repository_name, load_hash)
    formatted = empty_formatted_hash(repository_name, load_hash)
    load_hash[repository_name].map do |dataset_name, file_path|
      formatted = CSVExtractor.new(file_path, dataset_name).add_data_to_hash(formatted)
    end
    formatted
  end

  def empty_formatted_hash(repository_name, load_hash)
    dataset_hash = create_hash_identical_value(load_hash[repository_name].keys, nil)
    create_hash_identical_value(district_list(load_hash), dataset_hash)
  end

  def create_hash_identical_value(list, value)
    list.reduce({}) { |new_hash, element| new_hash.merge( {element => value} )}
  end

end

# This was the template I used to understand how inheritance works with classes and subclasses. Disregard this.
# To better understand this, go to the "operations" project.
# class Repository

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