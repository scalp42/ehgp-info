require 'models/base'

class Mandant < Base
  extend DatabaseHelpers

  # Listet alle Kantonskuerzel auf (cached)
  #
  # @return [Array] Liste aller Kantonskurzzeichen
  def self.kantone
    @@_kantone ||= select('"md_Kanton" as k from "Mandant"').map { |r| r[:k] }
  end

  # Findet einen Kanton nach seinem Kuerzel
  def self.find(kanton)
    fail Sinatra::NotFound unless kantone.include?(kanton)
    data = select_first '"md_ID" as id',
      ', "md_Kanton" as kanton',
      ', "md_Beschreibung" as name',
      'from "Mandant"',
      'where "md_Kanton" = ', kanton.surround("'")
    self.new(data)
  end

  # Findet alle Kantone mit Faktura-Spitalverträgen
  def self.with_faktura_contracts
    result = select '"md_ID" as id',
      ', "md_Kanton" as kanton',
      ', "md_Beschreibung" as name',
      ', count(*) as vertraege',
      'from "Mandant"',
      'left inner join "VertragMandantMitSpital" on "vt_md_ID" = "md_ID"',
      'where "vt_cd_LeMdFaktura" = 1',
      'group by "md_ID", "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung" asc'

    result.map { |data| self.new(data) }
  end
end
