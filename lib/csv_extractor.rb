require 'csv'

class CSVExtractor

  attr_reader :districts_hashes

  def initialize
    @districts_hashes = {
        :enrollment => {},
        :statewide_test => {},
        :economic_profile => {}
      }
  end

  def load_data(load_hash)
    load_hash.each_pair do |repository_type, dataset|
      dataset.each_pair do |dataset_name, file_path|
        csv_table = extract_csv(file_path)
        create_districts_hashes(repository_type, csv_table)
        merge_csv_data_into_districts_hashes(repository_type, dataset_name, csv_table)
      end
    end
  end

  def extract_csv(file_path)
    CSV.open(file_path, headers: true, header_converters: :symbol).read
  end

  def create_districts_hashes(repository_type, csv_table)
    csv_table[:location].uniq.each do |district_name|
      if @districts_hashes[repository_type][district_name.upcase].nil?
        @districts_hashes[repository_type].merge!({district_name.upcase => {:name => district_name.upcase}})
      end
    end
  end

  def merge_csv_data_into_districts_hashes(repository_type, dataset_name, csv_table)
    data_hash = extract_data_from_csv(csv_table)
    csv_table[:location].uniq.each do |district_name|
      district_name = district_name.upcase
      full_hash = {district_name => {dataset_name => data_hash[district_name]}}
      @districts_hashes[repository_type][district_name].merge!(full_hash[district_name])
    end
  end

  def extract_data_from_csv(csv_table)
    headers = determine_headers(csv_table)
    turn_csv_to_nested_hash(headers, csv_table, 0)
  end

  def turn_csv_to_nested_hash(headers, row_list, n)
    if n < headers.length-2
      index_n_list = row_list.map { |row| format_information(row, headers[n]) }.uniq.sort
      index_n_list.reduce({}) do |index_n_hash, index_n_object|
        index_n_row_list = row_list.find_all { |row| format_information(row, headers[n]) == index_n_object }
        index_n_hash.merge!({index_n_object => turn_csv_to_nested_hash(headers, index_n_row_list, n+1)})
      end
    else
      return_hash_top(row_list, headers, n)
    end
  end

  def return_hash_top(row_list, headers, n)
    row_list.reduce({}) do |child_hash, row|
      key = format_information(row, headers[n])
      value = format_information(row, headers[n+1])
      child_hash.merge({key => value})
    end
  end

  def format_information(csv_row, element_type)
    case element_type
    when :location
      csv_row[element_type].upcase
    when :timeframe
      csv_row[element_type].to_i
    when :data
      case csv_row[:dataformat]
      when "Percent"
        csv_row[element_type].to_f.round(3)
      when "Number", "Currency"
        csv_row[element_type].to_i
      end
    when :dataformat
      case csv_row[:dataformat]
      when "Percent"
        :percentage
      when "Number"
        :total
      end
    when :score
      csv_row[element_type].downcase.to_sym
    when :category, :race_ethnicity
      case csv_row[element_type]
      when "Asian", "Asian Students"
        :asian
      when "Black", "Black Students"
        :black
      when "Hawaiian/Pacific Islander", "Native Hawaiian or Other Pacific Islander"
        :pacific_islander
      when "Hispanic", "Hispanic Students"
        :hispanic
      when "Native American", "Native American Students"
        :native_american
      when "Two or more", "Two or More Races"
        :two_or_more
      when "White", "White Students"
        :white
      else
        csv_row[element_type].gsub(" ","_").downcase.to_sym
      end
    else
      # poverty level = ???
      csv_row[element_type]
    end
  end

  def determine_headers(csv_table)
    headers = csv_table.headers
    headers.delete(:dataformat) unless include_dataformat?(csv_table)
    headers
  end

  def include_dataformat?(csv_table)
    csv_table[:dataformat].uniq.length > 1 ? true : false
  end

  def get_district_list
    districts_list = @districts_hashes.map { |key, value| @districts_hashes[key].keys }.flatten.uniq.sort
    districts_list.map { |district_name| {:name => district_name} }
  end

end