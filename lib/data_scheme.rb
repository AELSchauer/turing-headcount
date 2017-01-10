require 'pry'
require './lib/exceptions'

class DataScheme
  include Exceptions

  attr_reader   :name,
                :data

  def initialize(info_hash)
    extract_information(info_hash)
  end

  def extract_information(info_hash)
    @name = info_hash[:name].upcase
    @data = info_hash.dup
    @data.delete(:name)
    nil
  end

  def [](data_key)
    @data[data_key]
  end

end