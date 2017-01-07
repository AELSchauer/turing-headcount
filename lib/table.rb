class Table

  attr_reader :data,
              :headers

  # def extract_csv_table(csv_table)
  #   @headers = csv_table.headers
  #   @headers.delete_at(2)
  #   @data = csv_table.map { |row| [row[:location].upcase, row[:timeframe].to_i, row[:data].to_f.round(3)] }
  #   self
  # end

  def extract_csv_table(csv_table, repository_type)
    @headers = csv_table.headers
    @headers.delete_at(2)
    @data = csv_table.map { |row| [row[:location].upcase, row[:timeframe].to_i, convert_data_by_format(row[:data], row[:dataformat]] }
    self
  end

  def convert_data_by_format(data, dataformat)
    if dataformat == "Percent"
      data.to_f.round(3)
    elsif dataformat == "Number"
      data.to_i
    end
  end


  def insert_column(index, header=nil, data=nil)
    @headers.insert(index, header)
    @data.map { |row| row.insert(index, data) }
  end

  def merge(table)
    @data.concat(table.data)
  end

  def convert_to_hash
    new_hash = convert_year_data_to_hash
    hash_conversion(new_hash)
  end

  def convert_year_data_to_hash
    new_hash = @data.map { |row| row[0..-3].concat([{row[-2] => row[-1]}]) }
  end

  def hash_conversion(data)
    new_hash = data.group_by { |row| row[0] }
    new_hash.each_pair do |key, value|
      new_hash[key] = value.map { |row| row[1..-1] }
      if data[0].length == 2
        year_data = new_hash[key].flatten
        new_hash[key] = year_data.reduce({}) { |merged_hash, element| merged_hash.merge(element) }
      else
        new_hash[key] = hash_conversion(new_hash[key])
      end
    end
  end

  def length
    @data.length
  end

end