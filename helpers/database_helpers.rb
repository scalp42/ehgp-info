module DatabaseHelpers
  # Join together all +part+s of the query and return the Dataset
  #
  # @param [Array<String>] parts of a sql query
  # @return [Sequel::Dataset]
  def query(*parts)
    DB[parts.join(' ')]
  end
end
