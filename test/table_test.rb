require './lib/table'
require 'minitest/autorun'
require 'minitest/pride'
require 'csv'
require 'pry'


class TableTest < Minitest::Test

  def setup
    table_1 = Table.new
    table_2 = Table.new
    [table_1, table_2]
  end

  def csv_setup
    file_path_1 = 'test/fixtures/csv_extractor_1.csv'
    file_path_2 = 'test/fixtures/csv_extractor_2.csv'
    csv_table_1 = CSV.open(file_path_1, headers: true, header_converters: :symbol).read
    csv_table_2 = CSV.open(file_path_2, headers: true, header_converters: :symbol).read
    [csv_table_1, csv_table_2]
  end

  def table_csv_setup
    table_1, table_2 = setup
    csv_table_1, csv_table_2 = csv_setup
    table_1.extract_csv_table(csv_table_1)
    table_2.extract_csv_table(csv_table_2)
    [table_1, table_2]
  end

  def test_create
    table_1, table_2 = setup

    assert table_1
    assert_equal Table, table_1.class
  end

  def test_extract_csv_table
    table_1, table_2 = setup
    csv_table_1, csv_table_2 = csv_setup

    table_1.extract_csv_table(csv_table_1)
    table_2.extract_csv_table(csv_table_2)

    expected_headers = [:location, :timeframe, :data]
    expected_data = ["GREGVILLE", 2010, 0.100]

    assert_equal expected_headers, table_1.headers
    assert_equal expected_headers, table_2.headers
    assert_equal expected_data,    table_1.data[0]
  end

  def test_insert_column
    table_1, table_2 = table_csv_setup

    table_1.insert_column(1)
    table_1.insert_column(2, :repository_type, :enrollment)

    expected_headers = [:location, nil, :repository_type, :timeframe, :data]
    expected_data = ["GREGVILLE", nil, :enrollment, 2010, 0.100]

    assert_equal expected_headers, table_1.headers
    assert_equal expected_data,    table_1.data[0]
  end

end