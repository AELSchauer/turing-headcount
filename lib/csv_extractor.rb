require 'pry'
require 'csv'

class CSVExtractor

  attr_reader :contents,
              :headers

  def initialize(file_path, dataset_name=nil)
    @dataset_name = dataset_name
    read_file(file_path)
  end

  def read_file(file_path)
    @contents = CSV.open(file_path, headers: true, header_converters: :symbol).read
    @headers = @contents.headers
  end

  def district_list
    @contents[:location].map { |district| district.upcase }.uniq
  end

  def data_hash
    grouped = @contents.group_by { |row| row[:location] }
    grouped.reduce({}) do |formatted, (district, rows)|
      formatted.merge({district.upcase => year_data(rows)})
    end
  end

  def year_data(rows)
    rows.reduce({}) { |year_data, row| year_data.merge({row[:timeframe] => row[:data]}) }
  end

  def add_data_to_hash(formatted_hash)
    csv_data = data_hash
    csv_data.each do |district_name, data|
      formatted_hash[district_name][@dataset_name] = data
    end
    formatted_hash
  end

end