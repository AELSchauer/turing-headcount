require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_proficient_for_subject_by_grade
    swt = setup_with_partial_complete

    third_grade_math_query = swt.proficient_for_subject_by_grade(:math, 3)
    expected_data = partial_complete_dataset[:third_grade][:math]

    assert_equal expected_data, third_grade_math_query
  end

  def test_proficient_for_subject_by_grade_errors
    swt = setup_with_partial_complete

    assert_raises(Exceptions::UnknownDataError) do
      swt.proficient_for_subject_by_grade(:math, 1)
    end
    assert_raises(Exceptions::UnknownDataError) do
      swt.proficient_for_subject_by_grade(:history, 3)
    end
  end

  def test_proficient_for_subject_by_race
    swt = setup_with_complete

    asian_math_query = swt.proficient_for_subject_by_race(:math, :asian)
    expected_data = complete_dataset[:math][:asian]

    assert_equal expected_data, asian_math_query
  end

  def test_proficient_for_subject_by_race_errors
    swt = setup_with_partial_complete

    assert_raises(Exceptions::UnknownDataError) do
      swt.proficient_for_subject_by_race(:history, :asian)
    end
    assert_raises(Exceptions::UnknownDataError) do
      swt.proficient_for_subject_by_grade(:math, :asian)
    end
  end

  def test_unknown_error_handler
    swt = setup_with_partial_complete

    [3,8].each do |grade|
      assert_nil swt.unknown_error_handler(swt.grades.keys, grade, :grade)
      assert_nil swt.unknown_error_handler(swt.grades.keys, grade, :grade)
    end

    races = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
    races.each do |race|
      assert_nil swt.unknown_error_handler(swt.races, race, :race)
    end

    subjects = [:math, :reading, :writing]
    subjects.each do |subject|
      assert_nil swt.unknown_error_handler(swt.subjects, subject, :subject)
    end

    assert_raises(Exceptions::UnknownRaceError) do
      swt.unknown_error_handler(swt.races, :martian, :race)
    end

    assert_raises(Exceptions::UnknownRaceError) do
      swt.unknown_error_handler(swt.races, nil, :race)
    end

    assert_raises(Exceptions::UnknownDataError) do
      swt.unknown_error_handler(swt.grades.keys, 9, :grade)
    end

    assert_raises(Exceptions::UnknownDataError) do
      swt.unknown_error_handler(swt.grades.keys, nil, :grade)
    end

    assert_raises(Exceptions::UnknownDataError) do
      swt.unknown_error_handler(swt.subjects, :history, :subject)
    end

    assert_raises(Exceptions::UnknownDataError) do
      swt.unknown_error_handler(swt.subjects, nil, :subject)
    end

    assert_raises(Exceptions::UnknownDataError) do
      swt.unknown_error_handler(swt.subjects, subjects, :subject)
    end
  end

  def setup_with_partial_complete
    swt = StatewideTest.new(partial_complete_dataset)
  end

  def setup_with_complete
    swt = StatewideTest.new(complete_dataset)
  end

  def complete_dataset
  {
    :name => "COLORADO",
    :third_grade=>{
      :math=>{2008=>0.697, 2009=>0.691, 2010=>0.706, 2011=>0.696, 2012=>0.71, 2013=>0.723, 2014=>0.716},
      :reading=>{2008=>0.703, 2009=>0.726, 2010=>0.698, 2011=>0.728, 2012=>0.739, 2013=>0.733, 2014=>0.716},
      :writing=>{2008=>0.501, 2009=>0.536, 2010=>0.504, 2011=>0.513, 2012=>0.525, 2013=>0.509, 2014=>0.511}
    },
    :eighth_grade=>{
      :math=>{2008=>0.469, 2009=>0.499, 2010=>0.51, 2011=>0.513, 2012=>0.515, 2013=>0.515, 2014=>0.524},
      :reading=>{2008=>0.703, 2009=>0.726, 2010=>0.679, 2011=>0.67, 2012=>0.671, 2013=>0.669, 2014=>0.664},
      :writing=>{2008=>0.529, 2009=>0.528, 2010=>0.549, 2011=>0.543, 2012=>0.548, 2013=>0.558, 2014=>0.562}
    },
    :math=>{
      :all_students=>{2011=>0.557, 2012=>0.558, 2013=>0.567, 2014=>0.564},
      :asian=>{2011=>0.709, 2012=>0.719, 2013=>0.732, 2014=>0.734},
      :black=>{2011=>0.333, 2012=>0.336, 2013=>0.355, 2014=>0.347},
      :hispanic=>{2011=>0.393, 2012=>0.39, 2013=>0.402, 2014=>0.396},
      :native_american=>{2011=>0.398, 2012=>0.401, 2013=>0.407, 2014=>0.376},
      :pacific_islander=>{2011=>0.541, 2012=>0.505, 2013=>0.525, 2014=>0.519},
      :two_or_more=>{2011=>0.61, 2012=>0.615, 2013=>0.62, 2014=>0.616},
      :white=>{2011=>0.659, 2012=>0.662, 2013=>0.67, 2014=>0.671}
    },
    :reading=>{
      :all_students=>{2011=>0.68, 2012=>0.693, 2013=>0.695, 2014=>0.69},
      :asian=>{2011=>0.748, 2012=>0.757, 2013=>0.769, 2014=>0.77},
      :black=>{2011=>0.486, 2012=>0.516, 2013=>0.52, 2014=>0.517},
      :hispanic=>{2011=>0.498, 2012=>0.516, 2013=>0.528, 2014=>0.52},
      :native_american=>{2011=>0.527, 2012=>0.549, 2013=>0.546, 2014=>0.523},
      :pacific_islander=>{2011=>0.659, 2012=>0.642, 2013=>0.682, 2014=>0.668},
      :two_or_more=>{2011=>0.744, 2012=>0.76, 2013=>0.76, 2014=>0.752},
      :white=>{2011=>0.789, 2012=>0.802, 2013=>0.8, 2014=>0.798}
    },
    :writing=>{
      :all_students=>{2011=>0.553, 2012=>0.54, 2013=>0.55, 2014=>0.544},
      :asian=>{2011=>0.657, 2012=>0.659, 2013=>0.682, 2014=>0.685},
      :black=>{2011=>0.37, 2012=>0.367, 2013=>0.378, 2014=>0.375},
      :hispanic=>{2011=>0.368, 2012=>0.366, 2013=>0.377, 2014=>0.376},
      :native_american=>{2011=>0.379, 2012=>0.366, 2013=>0.366, 2014=>0.339},
      :pacific_islander=>{2011=>0.558, 2012=>0.512, 2013=>0.519, 2014=>0.531},
      :two_or_more=>{2011=>0.617, 2012=>0.607, 2013=>0.612, 2014=>0.603},
      :white=>{2011=>0.663, 2012=>0.645, 2013=>0.656, 2014=>0.647}
    }
  }
  end

  def partial_complete_dataset
    {
      :name=>"ASHLEYVILLE",
      :third_grade =>{
        :math=>{2008=>0.486, 2009=>0.394, 2010=>0.656, 2011=>0.0, 2012=>0.792, 2013=>0.5, 2014=>0.57},
        :reading=>{2008=>0.583, 2009=>0.727, 2010=>0.719, 2011=>0.0, 2012=>0.792, 2013=>0.679, 2014=>0.789},
        :writing=>{2008=>0.0, 2009=>0.0, 2010=>0.406, 2011=>0.0, 2012=>0.667, 2013=>0.393, 2014=>0.316}
      },
      :eighth_grade =>{
        :math=>{2008=>0.486, 2009=>0.394, 2010=>0.656, 2011=>0.0, 2012=>0.792, 2013=>0.5, 2014=>0.57},
        :reading=>{2008=>0.583, 2009=>0.727, 2010=>0.719, 2011=>0.0, 2012=>0.792, 2013=>0.679, 2014=>0.789},
        :writing=>{2008=>0.0, 2009=>0.0, 2010=>0.406, 2011=>0.0, 2012=>0.667, 2013=>0.393, 2014=>0.316}
      }
    }
  end
end