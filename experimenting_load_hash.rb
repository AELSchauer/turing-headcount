require 'csv'

class ExperimentingLoadHash

  attr_reader :districts_hashes

  def initialize
    @districts_hashes = {
        :enrollment => {},
        :statewide_testing => {},
        :economic_profile => {}
      }
  end

  # def read_hash(load_hash)
  #   load_hash.each_pair do |repo_type, dataset|
  #     dataset.each_pair do |dataset_name, file_path|
  #       csv_table = extract_csv(file_path)
  #       create_hash_from_csv(dataset_name, csv_table)
  #     end
  #   end
  # end

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
    csv_table[:location].uniq.each do |district_name|
      district_name = district_name.upcase
      data_hash = extract_data_from_csv(csv_table, district_name)
      full_hash = {district_name => {dataset_name => data_hash[district_name]}}
      @districts_hashes[repository_type][district_name].merge!(full_hash[district_name])
    end
  end

  def extract_data_from_csv(csv_table, district_name)
    headers = determine_headers(csv_table)
    yay = turn_csv_to_nested_hash(headers, csv_table, district_name)
  end

  def turn_csv_to_nested_hash(headers, row_list, element)
    if headers.length > 2
      child_row_list = get_child_row_list(row_list, headers[0], element)
      element_list = get_element_list(child_row_list, headers[1])
      child_hash = element_list.reduce({}) do |child_hash, child_element|
        child_hash.merge(turn_csv_to_nested_hash(headers[1..-1], child_row_list, child_element))
      end
      {element => child_hash}
    else
      return_hash_top(row_list, headers)
    end
  end

  def get_child_row_list(row_list, header, element)
    row_list.find_all { |row| row[header].upcase == element.upcase}
  end

  def get_element_list(row_list, header)
    row_list.map { |row| row[header] }.uniq
  end

  def return_hash_top(row_list, headers)
    row_list.reduce({}) do |child_hash, row|
      key = format_information(row, headers[0])
      value = format_information(row, headers[1])
      child_hash.merge({key => value})
    end
  end

  def format_information(csv_row, element_type)
    if element_type == :timeframe
      csv_row[element_type].to_i
    elsif element_type == :data
      if csv_row[:dataformat] == "Percent"
        csv_row[element_type].to_f.round(3)
      end
    end
  end

  def determine_headers(csv_table)
    headers = csv_table.headers
    # headers.delete(:location)
    headers.delete(:dataformat) unless include_dataformat?(csv_table)
    headers
  end

  def include_dataformat?(csv_table)
    csv_table[:dataformat].uniq.length > 1 ? true : false
  end

end