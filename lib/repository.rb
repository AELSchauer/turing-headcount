require 'pry'
require './lib/csv_extractor'

class Repository

  attr_reader :data_scheme_links,
              :repository_type,
              :data_class

  def initialize
    @data_scheme_links = {}
    @repository_type = nil
    @data_class = nil
    @state_name = "COLORADO"
  end

  def load_data(load_hash)
    extractor = load_hash_extractor(load_hash)
    districts = extractor.districts_hashes[@repository_type]
    create_data_scheme_objects(districts)
  end

  def load_hash_extractor(load_hash)
    extractor = CSVExtractor.new
    extractor.load_data(load_hash)
    extractor
  end

  def create_data_scheme_objects(districts)
    districts.each_pair do |district_name, district_data|
      @data_scheme_links.merge!({district_name => @data_class.new(district_data)})
    end
  end

  def find_by_name(district_name)
    @data_scheme_links[district_name.upcase]
  end

  def find_all_matching(district_name_snippet)
    n = district_name_snippet.length-1
    @data_scheme_links.keys.find_all { |district_name| district_name[0..n] == district_name_snippet }
  end

end