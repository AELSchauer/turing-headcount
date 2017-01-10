require 'pry'
require './lib/repository'
require './lib/enrollment_repository'
require './lib/statewide_test_repository'
require './lib/economic_profile_repository'
require './lib/district'

class DistrictRepository < Repository

  attr_reader :repository_links

  def initialize
    super
    @repository_links = {
        :enrollment => EnrollmentRepository.new,
        :statewide_test => StatewideTestRepository.new,
        :economic_profile => EconomicProfileRepository.new,
      }
  end

  def load_data(load_hash)
    extractor = load_hash_extractor(load_hash)
    district_list = extractor.get_district_list
    create_districts(district_list)
    load_repositories(load_hash)
    link_data_scheme_objects_to_districts
  end

  def get_district_list(include_state_name)
    district_list = data_scheme_links.keys
    district_list.delete(@state_name) unless include_state_name[:include_state]
    district_list
  end

  def create_districts(district_list)
    district_list.each do |district|
      if @data_scheme_links[district[:name]].nil?
        @data_scheme_links.merge!({district[:name] => District.new(district)})
      end
    end
  end

  def load_repositories(load_hash)
    load_hash.keys.each do |repository_type|
      class_load_hash = {repository_type => load_hash[repository_type]}
      @repository_links[repository_type].load_data(class_load_hash)
    end
  end

  def link_data_scheme_objects_to_districts
    @data_scheme_links.each_pair do |district_name, district|
      @repository_links.each_pair do |repository_type, repository|
        data_scheme_object = repository.find_by_name(district_name)
        district.create_connection(repository_type, data_scheme_object) unless data_scheme_object.nil?
      end
    end
  end

end