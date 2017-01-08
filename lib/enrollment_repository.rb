require 'pry'
require './lib/repository'
require './lib/enrollment'

class EnrollmentRepository < Repository

  def initialize
    super
    @repository_type = :enrollment
    @data_class = Enrollment
  end

end