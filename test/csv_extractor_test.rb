require 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'simplecov'
SimpleCov.start

require './lib/csv_extractor'

class CSVExtractorTest < Minitest::Test

  def setup
    CSVExtractor.new
  end

  def test_create
    extractor = setup

    expected_data = {
        :enrollment => {},
        :statewide_testing => {},
        :economic_profile => {}
      }

    assert_equal expected_data, extractor.districts_hashes
  end

  def test_extract_csv
    extractor = setup

    csv = extractor.extract_csv(CSVFiles.generic_csv_file(1))

    expected_headers = [:location, :timeframe, :dataformat, :data]

    assert_equal CSV::Table,       csv.class
    assert_equal expected_headers, csv.headers
    assert_equal "gregville",      csv[0][:location]
  end

  def test_determine_headers
    extractor = setup
    csv_1 = extractor.extract_csv(CSVFiles.generic_csv_file(1))
    csv_2 = extractor.extract_csv(CSVFiles.generic_csv_file(2))
    csv_3 = extractor.extract_csv(CSVFiles.generic_csv_file(3))

    headers_1 = extractor.determine_headers(csv_1)
    headers_2 = extractor.determine_headers(csv_2)
    headers_3 = extractor.determine_headers(csv_3)

    expected_headers_1 = [:location, :timeframe, :data]
    expected_headers_2 = [:location, :subject, :timeframe, :data]
    expected_headers_3 = [:location, :timeframe, :dataformat, :data]

    assert_equal expected_headers_1, headers_1
    assert_equal expected_headers_2, headers_2
    assert_equal expected_headers_3, headers_3
  end

  def test_create_districts_hashes
    extractor, csv = setup_with_generic_csv_file(1)

    extractor.create_districts_hashes(:enrollment, csv)

    expected_data = {
        "GREGVILLE" => {:name => "GREGVILLE"},
        "ASHLEYVILLE" => {:name => "ASHLEYVILLE"}
      }

    assert_equal expected_data, extractor.districts_hashes[:enrollment]
  end

  def test_extract_data_from_csv
    extractor, csv = setup_with_generic_csv_file(2)

    extractor.create_districts_hashes(:enrollment, csv)
    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_2, csv)

    expected_data = {
      "GREGVILLE" => {
        :name => "GREGVILLE",
        :generic_csv_data_2 => {
          "Math" => {2010 => 0.11, 2011 => 0.21, 2012 => 0.31},
          "Reading" => {2010 => 0.115, 2011 => 0.215, 2012 => 0.315}
        }
      },
      "ASHLEYVILLE" => {
        :name => "ASHLEYVILLE",
        :generic_csv_data_2 => {
          "Math" => {2010 => 0.41, 2011 => 0.51, 2012 => 0.61},
          "Reading" => {2010 => 0.415, 2011 => 0.515, 2012 => 0.615}
        }
      }
    }

    assert_equal expected_data, extractor.districts_hashes[:enrollment]
  end

  def test_extract_data_from_multiple_csvs
    extractor = setup
    csv_1 = extractor.extract_csv(CSVFiles.generic_csv_file(1))
    csv_2 = extractor.extract_csv(CSVFiles.generic_csv_file(2))

    extractor.create_districts_hashes(:enrollment, csv_1)
    extractor.create_districts_hashes(:enrollment, csv_2)
    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_1, csv_1)
    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_2, csv_2)

    expected_data = {
      "GREGVILLE" => {
        :name => "GREGVILLE",
        :generic_csv_data_1 => {2010 => 0.1, 2011 => 0.2, 2012 => 0.3},
        :generic_csv_data_2 => {
          "Math" => {2010 => 0.11, 2011 => 0.21, 2012 => 0.31},
          "Reading" => {2010 => 0.115, 2011 => 0.215, 2012 => 0.315}
        }
      },
      "ASHLEYVILLE" => {
        :name => "ASHLEYVILLE",
        :generic_csv_data_1 => {
          2010 => 0.4, 2011 => 0.5, 2012 => 0.6
        },
        :generic_csv_data_2 => {
          "Math" => {2010 => 0.41, 2011 => 0.51, 2012 => 0.61},
          "Reading" => {2010 => 0.415, 2011 => 0.515, 2012 => 0.615}
        }
      }
    }

    assert_equal expected_data, extractor.districts_hashes[:enrollment]
  end

  def test_load_data
    extractor = setup

    extractor.load_data(CSVFiles.small_data_set)

    expected_data = {
      :enrollment => {
        "COLORADO" => {
          :name => "COLORADO",
          :kindergarten => {2007 => 0.395, 2006 => 0.337, 2005 => 0.278, 2004 => 0.24, 2008 => 0.536, 2009 => 0.598, 2010 => 0.64, 2011 => 0.672, 2012 => 0.695, 2013 => 0.703, 2014 => 0.741}
        },
        "GREGVILLE" => {
          :name => "GREGVILLE",
          :kindergarten => {2007 => 0.392, 2006 => 0.354, 2005 => 0.267, 2004 => 0.302, 2008 => 0.385, 2009 => 0.39, 2010 => 0.436, 2011 => 0.489, 2012 => 0.479, 2013 => 0.488, 2014 => 0.49}
        },
        "TURINGTOWN" => {
          :name => "TURINGTOWN",
          :kindergarten => {2007 => 0.306, 2006 => 0.293, 2005 => 0.3, 2004 => 0.228, 2008 => 0.673, 2009 => 1.0, 2010 => 1.0, 2011 => 1.0, 2012 => 1.0, 2013 => 0.998, 2014 => 1.0}
        }
      },
      :statewide_testing => {
        "COLORADO" => {
          :name => "COLORADO",
          :third_grade => {
            "Math" => {2008 => 0.697, 2009 => 0.691, 2010 => 0.706, 2011 => 0.696, 2012 => 0.71, 2013 => 0.723, 2014 => 0.716},
            "Reading" => {2008 => 0.703, 2009 => 0.726, 2010 => 0.698, 2011 => 0.728, 2012 => 0.739, 2013 => 0.733, 2014 => 0.716},
            "Writing" => {2008 => 0.501, 2009 => 0.536, 2010 => 0.504, 2011 => 0.513, 2012 => 0.525, 2014 => 0.511, 2013 => 0.509}
          }
        },
        "ASHLEYVILLE" => {
          :name => "ASHLEYVILLE",
          :third_grade => {
            "Math" => {2008 => 0.857, 2009 => 0.824, 2010 => 0.849, 2011 => 0.819, 2012 => 0.83, 2013 => 0.855, 2014 => 0.835},
            "Reading" => {2008 => 0.866, 2009 => 0.862, 2010 => 0.864, 2011 => 0.867, 2012 => 0.87, 2013 => 0.859, 2014 => 0.831},
            "Writing" => {2008 => 0.671, 2009 => 0.706, 2010 => 0.662, 2011 => 0.678, 2012 => 0.655, 2014 => 0.639, 2013 => 0.669}
          }
        },
        "GREGVILLE" => {
          :name => "GREGVILLE",
          :third_grade => {
            "Math" => {2008 => 0.56, 2009 => 0.54, 2010 => 0.469, 2011 => 0.476, 2012 => 0.39, 2013 => 0.437, 2014 => 0.512},
            "Reading" => {2008 => 0.523, 2009 => 0.562, 2010 => 0.457, 2011 => 0.571, 2012 => 0.54, 2013 => 0.548, 2014 => 0.477},
            "Writing" => {2008 => 0.426, 2009 => 0.479, 2010 => 0.312, 2011 => 0.31, 2012 => 0.288, 2014 => 0.275, 2013 => 0.284}
          }
        }
      },
      :economic_profile => {
        "COLORADO" => {
          :name => "COLORADO",
          :median_household_income => {2005 => 56222, 2006 => 56456, 2008 => 58244, 2007 => 57685, 2009 => 58433}
        },
        "ASHLEYVILLE" => {
          :name => "ASHLEYVILLE",
          :median_household_income => {2005 => 85060, 2006 => 85450, 2008 => 89615, 2007 => 88099, 2009 => 89953}
        },
        "GREGVILLE" => {
          :name => "GREGVILLE",
          :median_household_income => {2005 => 41382, 2006 => 40740, 2008 => 41886, 2007 => 41430, 2009 => 41088}
        }
      }
    }

    assert_equal expected_data, extractor.districts_hashes
  end

  def test_get_district_list
    extractor = setup_big_data_set

    district_list = extractor.get_district_list
    expected_list = [{:name=>"ASHLEYVILLE"}, {:name=>"COLORADO"}, {:name=>"GREGVILLE"}, {:name=>"TURINGTOWN"}]

    assert_equal expected_list, district_list
  end

  def setup_with_generic_csv_file(n)
    extractor = setup
    [extractor, extractor.extract_csv(CSVFiles.generic_csv_file(n))]
  end

  def setup_big_data_set
    extractor = setup
    extractor.load_data(CSVFiles.big_data_set)
    extractor
  end

end