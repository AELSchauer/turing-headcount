require './test/test_helper'
require './lib/csv_extractor'

class CSVExtractorTest < Minitest::Test

  def test_create
    extractor = setup

    expected_data = {
        :enrollment=>{},
        :statewide_test=>{},
        :economic_profile=>{}
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
    csv_4 = extractor.extract_csv(CSVFiles.generic_csv_file(4))
    csv_5 = extractor.extract_csv(CSVFiles.generic_csv_file(5))


    headers_1 = extractor.determine_headers(csv_1)
    headers_2 = extractor.determine_headers(csv_2)
    headers_3 = extractor.determine_headers(csv_3)
    headers_4 = extractor.determine_headers(csv_4)
    headers_5 = extractor.determine_headers(csv_5)

    expected_headers_1 = [:location, :timeframe, :data]
    expected_headers_2 = [:location, :score, :timeframe, :data]
    expected_headers_3 = [:location, :timeframe, :dataformat, :data]
    expected_headers_4 = [:location, :category, :timeframe, :data]
    expected_headers_5 = [:location, :race_ethnicity, :timeframe, :data]

    assert_equal expected_headers_1, headers_1
    assert_equal expected_headers_2, headers_2
    assert_equal expected_headers_3, headers_3
    assert_equal expected_headers_4, headers_4
    assert_equal expected_headers_5, headers_5
  end

  def test_create_districts_hashes
    extractor, csv = setup_with_generic_csv_file(1)

    extractor.create_districts_hashes(:enrollment, csv)

    expected_data = {
        "GREGVILLE"=>{:name=>"GREGVILLE"},
        "ASHLEYVILLE"=>{:name=>"ASHLEYVILLE"}
      }

    assert_equal expected_data, extractor.districts_hashes[:enrollment]
  end

  def test_extract_data_from_csv
    extractor, csv = setup_with_generic_csv_file(2)

    extractor.create_districts_hashes(:enrollment, csv)
    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_2, csv)

    expected_data = {
      "GREGVILLE"=>{
        :name=>"GREGVILLE",
        :generic_csv_data_2=>{
          :math=>{2010=>0.11, 2011=>0.21, 2012=>0.31},
          :reading=>{2010=>0.115, 2011=>0.215, 2012=>0.315}
        }
      },
      "ASHLEYVILLE"=>{
        :name=>"ASHLEYVILLE",
        :generic_csv_data_2=>{
          :math=>{2010=>0.41, 2011=>0.51, 2012=>0.61},
          :reading=>{2010=>0.415, 2011=>0.515, 2012=>0.615}
        }
      }
    }

    assert_equal expected_data, extractor.districts_hashes[:enrollment]
  end

  def test_extract_data_from_multiple_csvs
    extractor = setup
    csv_1 = extractor.extract_csv(CSVFiles.generic_csv_file(2))
    csv_2 = extractor.extract_csv(CSVFiles.generic_csv_file(4))
    csv_3 = extractor.extract_csv(CSVFiles.generic_csv_file(5))

    extractor.create_districts_hashes(:enrollment, csv_1)
    extractor.create_districts_hashes(:enrollment, csv_2)
    extractor.create_districts_hashes(:enrollment, csv_3)

    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_1, csv_1)
    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_2, csv_2)
    extractor.merge_csv_data_into_districts_hashes(:enrollment, :generic_csv_data_3, csv_3)

    expected_data = expected_hash_for_generic_csv_files_2_4_5

    assert_equal expected_data, extractor.districts_hashes[:enrollment]
  end

  def test_load_data
    extractor = setup
    extractor.load_data(CSVFiles.small_data_set)

    expected_data = expected_hash_for_small_data_set

    assert_equal expected_data, extractor.districts_hashes
  end

  def test_get_district_list
    extractor = setup_big_data_set

    district_list = extractor.get_district_list
    expected_list = [{:name=>"ASHLEYVILLE"}, {:name=>"COLORADO"}, {:name=>"GREGVILLE"}, {:name=>"TURINGTOWN"}]

    assert_equal expected_list, district_list
  end

  def setup
    CSVExtractor.new
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

  def expected_hash_for_generic_csv_files_2_4_5
    {
      "GREGVILLE"=>{
        :name=>"GREGVILLE",
        :generic_csv_data_1=>{
          :math=>{2010=>0.11, 2011=>0.21, 2012=>0.31},
          :reading=>{2010=>0.115, 2011=>0.215, 2012=>0.315}
        },
        :generic_csv_data_2=>{
          :all_students=>{2011=>0.002, 2012=>0.004},
          :asian=>{2011=>0.0, 2012=>0.007},
          :black=>{2011=>0.0, 2012=>0.002},
          :female_students=>{2011=>0.002, 2012=>0.004},
          :hispanic=>{2011=>0.004, 2012=>0.006},
          :male_students=>{2011=>0.002, 2012=>0.004},
          :native_american=>{2011=>0.0, 2012=>0.036},
          :pacific_islander=>{2011=>0.0, 2012=>0.0},
          :two_or_more=>{2011=>0.0, 2012=>0.0},
          :white=>{2011=>0.002, 2012=>0.004}
        }
      },
      "ASHLEYVILLE"=>{
        :name=>"ASHLEYVILLE",
        :generic_csv_data_1=>{
          :math=>{2010=>0.41, 2011=>0.51, 2012=>0.61},
          :reading=>{2010=>0.415, 2011=>0.515, 2012=>0.615}
        },
        :generic_csv_data_2=>{
          :all_students=>{2011=>0.072, 2012=>0.063},
          :asian=>{2011=>0.083, 2012=>0.0},
          :black=>{2011=>0.08, 2012=>0.037},
          :female_students=>{2011=>0.062, 2012=>0.051},
          :hispanic=>{2011=>0.073, 2012=>0.066},
          :male_students=>{2011=>0.081, 2012=>0.075},
          :native_american=>{2011=>0.206, 2012=>0.065},
          :pacific_islander=>{2011=>0.0, 2012=>0.0},
          :two_or_more=>{2011=>0.0, 2012=>0.0},
          :white=>{2011=>0.058, 2012=>0.058}
        },
        :generic_csv_data_3=>{
          :all_students=>{2011=>0.317, 2012=>0.28, 2013=>0.303, 2014=>0.298},
          :asian=>{2011=>0.0, 2012=>0.0, 2013=>0.0, 2014=>0.0},
          :black=>{2011=>0.226, 2012=>0.216, 2013=>0.259, 2014=>0.218},
          :hispanic=>{2011=>0.312, 2012=>0.279, 2013=>0.299, 2014=>0.293},
          :native_american=>{2011=>0.364, 2012=>0.346, 2013=>0.32, 2014=>0.321},
          :pacific_islander=>{2011=>0.0, 2012=>0.0, 2013=>0.0, 2014=>0.0},
          :two_or_more=>{2011=>0.5, 2012=>0.435, 2013=>0.25, 2014=>0.382},
          :white=>{2011=>0.346, 2012=>0.276, 2013=>0.339, 2014=>0.34}
        }
      },
      "COLORADO"=>{
        :name=>"COLORADO",
        :generic_csv_data_2=>{
          :all_students=>{2011=>0.03, 2012=>0.029},
          :asian=>{2011=>0.017, 2012=>0.016},
          :black=>{2011=>0.044, 2012=>0.044},
          :female_students=>{2011=>0.028, 2012=>0.027},
          :hispanic=>{2011=>0.049, 2012=>0.047},
          :male_students=>{2011=>0.032, 2012=>0.032},
          :native_american=>{2011=>0.065, 2012=>0.054},
          :pacific_islander=>{2011=>0.029, 2012=>0.038},
          :two_or_more=>{2011=>0.017, 2012=>0.017},
          :white=>{2011=>0.02, 2012=>0.019}
        },
        :generic_csv_data_3=>{
          :all_students=>{2011=>0.553, 2012=>0.54, 2013=>0.55, 2014=>0.544},
          :asian=>{2011=>0.657, 2012=>0.659, 2013=>0.682, 2014=>0.685},
          :black=>{2011=>0.37, 2012=>0.367, 2013=>0.378, 2014=>0.375},
          :hispanic=>{2011=>0.368, 2012=>0.366, 2013=>0.377, 2014=>0.376},
          :native_american=>{2011=>0.379, 2012=>0.366, 2013=>0.366, 2014=>0.339},
          :pacific_islander=>{2011=>0.558, 2012=>0.512, 2013=>0.519, 2014=>0.531},
          :two_or_more=>{2011=>0.617, 2012=>0.607, 2013=>0.612, 2014=>0.603},
          :white=>{2011=>0.663, 2012=>0.645, 2013=>0.656, 2014=>0.647}
        }
      },
      "TURINGTOWN"=>{
        :name=>"TURINGTOWN",
        :generic_csv_data_3=>{
          :all_students=>{2011=>0.719, 2012=>0.706, 2013=>0.72, 2014=>0.716},
          :asian=>{2011=>0.827, 2012=>0.808, 2013=>0.811, 2014=>0.789},
          :black=>{2011=>0.515, 2012=>0.504, 2013=>0.482, 2014=>0.519},
          :hispanic=>{2011=>0.607, 2012=>0.598, 2013=>0.623, 2014=>0.624},
          :native_american=>{2011=>0.6, 2012=>0.589, 2013=>0.61, 2014=>0.621},
          :pacific_islander=>{2011=>0.726, 2012=>0.683, 2013=>0.717, 2014=>0.727},
          :two_or_more=>{2011=>0.727, 2012=>0.719, 2013=>0.747, 2014=>0.732},
          :white=>{2011=>0.74, 2012=>0.726, 2013=>0.741, 2014=>0.735}
        }
      }
    }
  end

  def expected_hash_for_small_data_set
    {
      :enrollment=>{
        "COLORADO"=>{
          :name=>"COLORADO",
          :kindergarten=>{2007=>0.395, 2006=>0.337, 2005=>0.278, 2004=>0.24, 2008=>0.536, 2009=>0.598, 2010=>0.64, 2011=>0.672, 2012=>0.695, 2013=>0.703, 2014=>0.741}
        },
        "GREGVILLE"=>{
          :name=>"GREGVILLE",
          :kindergarten=>{2007=>0.392, 2006=>0.354, 2005=>0.267, 2004=>0.302, 2008=>0.385, 2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.479, 2013=>0.488, 2014=>0.49}
        },
        "TURINGTOWN"=>{
          :name=>"TURINGTOWN",
          :kindergarten=>{2007=>0.306, 2006=>0.293, 2005=>0.3, 2004=>0.228, 2008=>0.673, 2009=>1.0, 2010=>1.0, 2011=>1.0, 2012=>1.0, 2013=>0.998, 2014=>1.0}
        }
      },
      :statewide_test=>{
        "COLORADO"=>{
          :name=>"COLORADO",
          :third_grade=>{
            :math=>{2008=>0.697, 2009=>0.691, 2010=>0.706, 2011=>0.696, 2012=>0.71, 2013=>0.723, 2014=>0.716},
            :reading=>{2008=>0.703, 2009=>0.726, 2010=>0.698, 2011=>0.728, 2012=>0.739, 2013=>0.733, 2014=>0.716},
            :writing=>{2008=>0.501, 2009=>0.536, 2010=>0.504, 2011=>0.513, 2012=>0.525, 2014=>0.511, 2013=>0.509}
          }
        },
        "ASHLEYVILLE"=>{
          :name=>"ASHLEYVILLE",
          :third_grade=>{
            :math=>{2008=>0.857, 2009=>0.824, 2010=>0.849, 2011=>0.819, 2012=>0.83, 2013=>0.855, 2014=>0.835},
            :reading=>{2008=>0.866, 2009=>0.862, 2010=>0.864, 2011=>0.867, 2012=>0.87, 2013=>0.859, 2014=>0.831},
            :writing=>{2008=>0.671, 2009=>0.706, 2010=>0.662, 2011=>0.678, 2012=>0.655, 2014=>0.639, 2013=>0.669}
          }
        },
        "GREGVILLE"=>{
          :name=>"GREGVILLE",
          :third_grade=>{
            :math=>{2008=>0.56, 2009=>0.54, 2010=>0.469, 2011=>0.476, 2012=>0.39, 2013=>0.437, 2014=>0.512},
            :reading=>{2008=>0.523, 2009=>0.562, 2010=>0.457, 2011=>0.571, 2012=>0.54, 2013=>0.548, 2014=>0.477},
            :writing=>{2008=>0.426, 2009=>0.479, 2010=>0.312, 2011=>0.31, 2012=>0.288, 2014=>0.275, 2013=>0.284}
          }
        }
      },
      :economic_profile=>{
        "COLORADO"=>{
          :name=>"COLORADO",
          :median_household_income=>{2005=>56222, 2006=>56456, 2008=>58244, 2007=>57685, 2009=>58433}
        },
        "ASHLEYVILLE"=>{
          :name=>"ASHLEYVILLE",
          :median_household_income=>{2005=>85060, 2006=>85450, 2008=>89615, 2007=>88099, 2009=>89953}
        },
        "GREGVILLE"=>{
          :name=>"GREGVILLE",
          :median_household_income=>{2005=>41382, 2006=>40740, 2008=>41886, 2007=>41430, 2009=>41088}
        }
      }
    }
  end

end