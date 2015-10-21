require 'models/base'

class Vertrag < Base
  extend DatabaseHelpers

  # Finde eFaktura-Vertraege anhand Mandanten-ID
  def self.for_mandant(id)
    result = select '"sp_ID" as id',
      ', "sp_Kanton" as kanton',
      ', "sp_Name" as name',
      ', "vt_cd_LeMdSystemkogu" as systemkogu',
      'from KOGU."StammSpital"',
      'inner join KOGU."VertragMandantMitSpital" on "vt_sp_ID" = "sp_ID"',
      'where "vt_md_ID" = ', id,
      'and "vt_cd_LeMdFaktura" = 1',
      'and "sp_cd_LeXmlZertifiziert" = 1',
      'order by "sp_Kanton" asc, "sp_Name" asc'

    result.map { |data| self.new(data) }
  end

  # Finde eFaktura-Vertraege anhand Spital-ID
  def self.for_spital(id)
    result = select '"md_Kanton" as kanton',
      ', "md_Beschreibung" as beschreibung',
      ', "vt_cd_LeMdSystemkogu" as systemkogu',
      'from KOGU."Mandant"',
      'inner join KOGU."VertragMandantMitSpital" on "vt_md_ID" = "md_ID"',
      'where "vt_sp_ID" = ', id,
      'and "vt_cd_LeMdFaktura" = 1',
      'order by "md_Beschreibung" asc'

    result.map { |data| self.new(data) }
  end
end
