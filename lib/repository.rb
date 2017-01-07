require 'pry'

class Repository

  attr_reader :data_links,
              :repo_links

  def initialize
    @data_links = {}
    @repo_links = {}
  end

  # def district_list(load_hash)
  #   load_hash.map { |repository_name, dataset|
  #     dataset.map { |dataset_name, file_path|
  #       CSVExtractor.new(file_path).district_list
  #     }
  #   }.flatten.sort.uniq
  # end

  # def district_data_hash(load_hash, repository_name)
  #   formatted = empty_formatted_hash(load_hash, repository_name)
  #   load_hash[repository_name].map do |dataset_name, file_path|
  #     formatted = CSVExtractor.new(file_path, dataset_name).add_data_to_hash(formatted)
  #   end
  #   formatted
  # end

  # def empty_formatted_hash(load_hash, repository_name)
  #   dataset_hash = create_hash_with_identical_values(load_hash[repository_name].keys, nil)
  #   create_hash_with_identical_values(district_list(load_hash), dataset_hash)
  # end

  # def create_hash_with_identical_values(list, value)
  #   list.reduce({}) { |new_hash, element| new_hash.merge( {element => value} )}
  # end

  # def find_by_name(district_name)
  #   @data_links[district_name.upcase]
  # end

  # def find_all_matching(district_name_snippet)
  #   n = district_name_snippet.length-1
  #   @data_links.keys.find_all { |district_name| district_name[0..n] == district_name_snippet }
  # end

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