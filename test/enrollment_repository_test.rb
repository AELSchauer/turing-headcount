require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def test_create
    er = setup

    assert_equal Hash.new,    er.data_scheme_links
    assert_equal :enrollment, er.repository_type
  end

  def test_load_data
    er = setup

    er.load_data(CSVFiles.big_data_set)

    assert_equal [:kindergarten, :high_school_graduation], er.data_scheme_links["COLORADO"].data.keys
    assert_equal [:kindergarten, :high_school_graduation], er.data_scheme_links["GREGVILLE"].data.keys
    assert_equal [:kindergarten],                          er.data_scheme_links["TURINGTOWN"].data.keys
    assert_equal [:high_school_graduation],                er.data_scheme_links["ASHLEYVILLE"].data.keys
  end

  def setup
    er = EnrollmentRepository.new
  end

end