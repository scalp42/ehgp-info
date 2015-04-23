module DatabaseHelpers
  # Join together all +part+s of the query and return the Dataset
  #
  # @param [Array<String>] parts the individual parts of a sql query
  # @return [Sequel::Dataset]
  def query(*parts)
    DB[parts.join(' ')]
  end

  # Makes a select on the database
  #
  # @param [Array<String>] query the rest of the query after +SELECT+
  # @return [Sequel::Dataset]
  def select(*query)
    query('select', *query)
  end

  # Makes a select on the database and returns the first row.
  #
  # THIS BREAKS LAZY LOADING!
  #
  # @param (see #select)
  # @return (see #select)
  def select_first(*query)
    select(*query).first
  end
end
