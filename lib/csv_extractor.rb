require 'pry'
require 'csv'
require './lib/table'

class CSVExtractor

  attr_reader :table_list

  def initialize
    @table_list = []
  end

  def read_file(file_path)
    contents = CSV.open(file_path, headers: true, header_converters: :symbol).read
    @table_list.push(Table.new)
    table = @table_list.last
    table.extract_csv_table(contents)
    table
  end

  def specify_data_categories(table, repository_type, dataset_name)
    table.insert_column(1, :repository_type, repository_type)
    table.insert_column(2, :dataset_name,    dataset_name)
  end

  def combine_all_tables
    main_table = @table_list[0]
    tables = @table_list[1..-1]
    tables.each do |table|
      main_table.merge(table)
    end
    @table_list = [main_table]
  end

  def convert_main_table_to_hash
    if @table_list.length > 1
      combine_all_tables
    end
    main_table = @table_list[0]
    main_table.convert_to_hash
  end

end