require 'models/base'

class Mandant < Base
  extend DatabaseHelpers

  # Listet alle Kantonskuerzel auf (cached)
  #
  # @return [Array] Liste aller Kantonskurzzeichen
  def self.kantone
    @@_kantone ||= select('"md_Kanton" as k from KOGU."Mandant"').map { |r| r[:k] }
  end

  # Findet einen Kanton nach seinem Kuerzel
  def self.find(kanton)
    fail Sinatra::NotFound unless kantone.include?(kanton)
    data = select_first '"md_ID" as id',
      ', "md_Kanton" as kanton',
      ', "md_Beschreibung" as name',
      'from KOGU."Mandant"',
      'where "md_Kanton" = ', kanton.surround("'")
    self.new(data)
  end

  # Findet alle Kantone mit Faktura-Spitalverträgen
  def self.with_faktura_contracts
    result = select '"md_ID" as id',
      ', "md_Kanton" as kanton',
      ', "md_Beschreibung" as name',
      ', count(*) as vertraege',
      'from KOGU."Mandant"',
      'left inner join KOGU."VertragMandantMitSpital" on "vt_md_ID" = "md_ID"',
      'where "vt_cd_LeMdFaktura" = 1',
      'group by "md_ID", "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung" asc'

    result.map { |data| self.new(data) }
  end

  # Finde alle Kantone mit Referenztarifen
  def self.with_reference_tarif
    result = select '"md_Kanton" as id',
                    ', "md_Beschreibung" as name',
                    ', count("rt_ReferenzCd") as tarife',
      'from KOGU."Mandant"',
      'inner join KOGU."Referenztarif" on "md_ID" = "rt_Mandant"',
      'group by "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung"'

    result.map { |data| self.new(data) }
  end
end
