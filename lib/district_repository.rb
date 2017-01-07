require './lib/repository'
require './lib/enrollment_repository'
require './lib/statewide_test_repository'
require './lib/economic_profile_repository'
require './lib/district'
require './lib/csv_extractor'
require 'pry'

class DistrictRepository < Repository

  def initialize
    super
    @repository_connections = {
        :enrollment => EnrollmentRepository,
        :statewide_testing => StatewideTestRepository,
        :economic_profile => EconomicProfileRepository
      }
  end

  def load_data(load_hash)
    create_districts(load_hash)
    create_schema(load_hash)
  end

  def link_repo(repository_name, repository_object)
    @repo_links[repository_name] = repository_object
  end

  def create_districts(load_hash)
    districts = district_list(load_hash)
    districts.each do |district_name|
      if @data_links[district_name].nil?
        district_object = District.new({:name => district_name})
        @data_links[district_name] = district_object
      end
    end
  end

  def create_schema(load_hash)
    load_hash.keys.each do |repository_type|
      create_and_link_to_repository(load_hash, repository_type)
      load_repository(load_hash, repository_type)
    end
  end

  def create_and_link_to_repository(load_hash, repository_type)
    if @repo_links[repository_type].nil?
      repository_class = get_repository_class(repository_type)
      @repo_links[repository_type] = repository_class.new
    end
  end

  def load_repository(load_hash, repository_type)
    repository = @repo_links[repository_type]
    repository.load_data(load_hash)
  end

  def get_repository_class(repository_type)
    @connections[repository_type]
  end

  # def load_statewide_tests(load_hash)
  #   repository_name = :statewide_test
  #   unless load_hash[repository_name].nil?
  #       if @repo_links[repository_name].nil?
  #       repository = StatewideTestRepository.new
  #       @repo_links[repository_name] = repository
  #     else
  #       repository = @repo_links[repository_name]
  #       repository.load_data(load_hash)
  #     end
  #   end
  # end

  # def load_economic_profile(load_hash)
  #   repository_name = :economic_profile
  #   unless load_hash[repository_name].nil?
  #       if @repo_links[repository_name].nil?
  #       repository = EconomicProfileRepository.new
  #       @repo_links[repository_name] = repository
  #     else
  #       repository = @repo_links[repository_name]
  #       repository.load_data(load_hash)
  #     end
  #   end
  # end

end