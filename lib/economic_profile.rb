require 'pry'
require './lib/data_scheme'

class EconomicProfile < DataScheme

  def initialize(info_hash)
    super(info_hash)
    @data = parse_out_array_keys
  end

  def median_household_income_in_year(year)
    retrieve_data_by_year(:median_household_income, year)
  end

  def median_household_income_average
    (@data[:median_household_income].values.reduce(:+) / @data[:median_household_income].values.count)
  end

  def children_in_poverty_in_year(year)
    retrieve_data_by_year(:children_in_poverty, year)
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    retrieve_data_by_year(:free_or_reduced_price_lunch, year, :percentage)
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    retrieve_data_by_year(:free_or_reduced_price_lunch, year, :total)
  end

  def title_i_in_year(year)
    retrieve_data_by_year(:title_i, year)
  end

  def retrieve_data_by_year(dataset_name, year, dataformat=nil)
    raise(UnknownDataError) unless @data[dataset_name].keys.include?(year)
    dataformat.nil? ? @data[dataset_name][year] : @data[dataset_name][year][dataformat]
  end

  def parse_out_array_keys
    @data.reduce({}) do |name_dataset_hash, (dataset_name, years_data)|
      dataset_hash = years_data.reduce({}) do |dataset_hash, (years, data)|
        if years.is_a?(Array)
          years_hash = years.reduce({}) { |years_hash, year| years_hash.merge!({year => data}) }
          dataset_hash.merge!(years_hash)
        else
          dataset_hash.merge!({years => data})
        end
      end
      name_dataset_hash.merge!({dataset_name => dataset_hash})
    end
  end

end