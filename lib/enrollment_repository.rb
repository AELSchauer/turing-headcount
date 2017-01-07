require './lib/repository'
require './lib/enrollment'
require './lib/csv_extractor'
require 'pry'

class EnrollmentRepository < Repository

  def initialize
    super
  end

  def load_data(load_hash)
    data_hash = district_data_hash(load_hash, :enrollment)
    create_or_update_enrollments(data_hash)
  end

  def create_or_update_enrollments(data_hash)
    data_hash.each do |district_name, data|
      if @data_links[district_name].nil?
        enrollment_object = Enrollment.new({:name => district_name}.merge(data))
        @data_links[district_name] = enrollment_object
      else
        enrollment_object = @data_links[district_name]
        enrollment_object.add_datasets(data)
      end
    end
  end

end