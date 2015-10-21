require 'models/base'

class Code < Base
  extend DatabaseHelpers

  # Find Codes by Type
  def self.by_type(type)
    result = select '"cd_ID" as id',
      ', "cd_Beschreibung" as text',
      'from KOGU."ISCode"',
      %Q{where "cd_Typ" = '#{type}'},
      'order by "cd_Sort" asc'

    result.map { |data| self.new(data) }
  end
end
