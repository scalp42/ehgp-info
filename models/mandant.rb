require 'models/base'

class Mandant < Base
  extend DatabaseHelpers

  # Listet alle Kantonskuerzel auf (cached)
  #
  # @return [Array] Liste aller Kantonskurzzeichen
  def self.kantone
    @@_kantone ||= select('"md_Kanton" as k from "Mandant"').map { |r| r[:k] }
  end

  def self.find(kanton)
    fail Sinatra::NotFound unless kantone.include?(kanton)
    data = select_first '"md_ID" as id',
      ', "md_Kanton" as kanton',
      ', "md_Beschreibung" as name',
      'from "Mandant"',
      'where "md_Kanton" = ', kanton.surround("'")
    self.new(data)
  end
end
