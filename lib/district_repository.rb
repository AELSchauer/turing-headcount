require './lib/repository'
require './lib/enrollment_repository'
# require './lib/statewide_test_repository'
# require './lib/economic_profile_repository'
require './lib/district'
require './lib/csv_extractor'
require 'pry'

class DistrictRepository < Repository

  def initialize
    super
  end

  def load_data(load_hash)
    districts = district_list(load_hash)
    create_districts(districts)
    load_enrollments(load_hash)
  end

  def create_districts(districts)
    districts.each do |district|
      district_name = district.upcase
      if @data_links[district_name].nil?
        district_object = District.new({:name => district_name})
        @data_links[district_name] = district_object
      end
    end
  end

  def link_repo(repository_name, repository_object)
    @repo_links[repository_name] = repository_object
  end

  def load_enrollments(load_hash)
    repository_name = :enrollment
    if @repo_links[repository_name].nil?
      repository = EnrollmentRepository.new
      @repo_links[repository_name] = repository
    else
      repository = @repo_links[repository_name]
      repository.load_data(load_hash)
    end
  end

  # def load_statewide_tests(load_hash)
  #   repository_name = :statewide_test
  #   if @repo_links[repository_name].nil?
  #     repository = StatewideTestRepository.new
  #     @repo_links[repository_name] = repository
  #   else
  #     repository = @repo_links[repository_name]
  #     repository.load_data(load_hash)
  #   end
  # end

  # def load_economic_profile(load_hash)
  #   repository_name = :economic_profile
  #   if @repo_links[repository_name].nil?
  #     repository = EconomicProfileRepository.new
  #     @repo_links[repository_name] = repository
  #   else
  #     repository = @repo_links[repository_name]
  #     repository.load_data(load_hash)
  #   end
  # end

end