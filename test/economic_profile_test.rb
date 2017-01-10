require './test/test_helper'
require './lib/economic_profile'

class EconomicProfileTest < Minitest::Test

  def test_create
    data = {:name => "ASHLEYVILLE", :children_in_poverty => {2012 => 0.184}}
    ep = EconomicProfile.new(data)

    expected_data = {:children_in_poverty => {2012 => 0.184}}

    assert_equal "ASHLEYVILLE", ep.name
    assert_equal expected_data, ep.data
  end

  def test_parse_out_array_keys
    ep, data = setup
    parsed_data = ep.parse_out_array_keys

    expected_data = {
      :median_household_income=>{2005=>50000, 2009=>50000, 2008=>60000, 2014=>60000},
      :children_in_poverty=>{2008=>0.184, 2012=>0.184},
      :free_or_reduced_price_lunch=>{2014=>{:percentage=>0.023, :total=>100}},
      :title_i=>{2015=>0.543}
    }

    assert_equal expected_data, parsed_data
  end

  def test_parse_out_array_keys_default
    ep, data = setup

    expected_data = {
      :median_household_income=>{2005=>50000, 2009=>50000, 2008=>60000, 2014=>60000},
      :children_in_poverty=>{2008=>0.184, 2012=>0.184},
      :free_or_reduced_price_lunch=>{2014=>{:percentage=>0.023, :total=>100}},
      :title_i=>{2015=>0.543}
    }

    assert_equal expected_data, ep.data
  end

  def test_median_household_income_in_year
    ep, data = setup

    assert_equal 50000, ep.median_household_income_in_year(2005)
    assert_equal 60000, ep.median_household_income_in_year(2014)
    assert_raises(Exceptions::UnknownDataError) do
      ep.median_household_income_in_year(2007)
    end
  end

  def test_median_household_income_average
    ep, data = setup

    assert_equal 220000, ep.data[:median_household_income].values.reduce(:+)
    assert_equal 4,      ep.data[:median_household_income].values.count
    assert_equal 55000,  ep.median_household_income_average
  end

  def setup
    data = markdown_data
    ep = EconomicProfile.new(data)
    [ep, data]
  end

  def markdown_data
    {
      :median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
      :children_in_poverty => {[2008, 2012] => 0.184},
      :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
      :title_i => {2015 => 0.543},
      :name => "ACADEMY 20"
    }
  end

end