require 'models/base'

class Spital < Base
  extend DatabaseHelpers

  def aktiv?
    aktiv < 50
  end

  def zertifiziert?
    zertifiziert == 1
  end

  def bezeichnung
    "#{kanton} #{name}, #{ort}"
  end

  class << self
    # Finde einen Spital nach seiner numerischen ID
    def find(id)
      data = select_first '"sp_ID" as id',
        ', "sp_Kanton" as kanton',
        ', "sp_Name" as name',
        ', "sp_EAN" as ean',
        ', "sp_Aktiv" as aktiv',
        ', "sp_cd_LeXmlZertifiziert" as zertifiziert',
        'from KOGU."StammSpital"',
        'where "sp_ID" =', id.to_i

      data.nil? ? nil : self.new(data)
    end

    # Alle XML-Spitaeler mit anz. Vertraegen
    def xml_with_contracts
      results = query 'select "sp_ID" as id',
        ', "sp_Kanton" as kanton',
        ', "sp_Name" as name',
        ', "sp_Ort" as ort',
        ', "sp_Aktiv" as aktiv',
        ', count ("vt_sp_ID") as vertraege',
        'from KOGU."StammSpital"',
        'left outer join KOGU."VertragMandantMitSpital" on "vt_sp_ID" = "sp_ID" and "vt_cd_LeMdFaktura" = 1',
        'where "sp_Aktiv" < 50 and "sp_cd_LeXmlZertifiziert" = 1',
        'group by "sp_ID","sp_Kanton", "sp_Name", "sp_Ort", "sp_Aktiv", "sp_cd_LeXmlZertifiziert"',
        'order by "sp_Kanton", "sp_Name"'

      results.map { |data| self.new(data) }
    end

    # Alle Spitaeler mit vertraegen, die nicht aktiv oder nicht Zugelassen sind.
    def invalid
      results = query 'select "sp_ID" as id',
        ', "sp_Kanton" as kanton',
        ', "sp_Name" as name',
        ', "sp_Ort" as ort',
        ', "sp_Aktiv" as aktiv',
        ', count ("vt_sp_ID") as vertraege',
        'from KOGU."StammSpital"',
        'inner join KOGU."VertragMandantMitSpital" on "vt_sp_ID" = "sp_ID" and "vt_cd_LeMdFaktura" = 1',
        'where ("sp_cd_LeXmlZertifiziert" != 1 or "sp_Aktiv" > 50)',
        'group by "sp_ID","sp_Kanton", "sp_Name", "sp_Ort", "sp_Aktiv", "sp_cd_LeXmlZertifiziert"',
        'order by "sp_Kanton", "sp_Name"'

      results.map { |data| self.new(data) }
    end
  end
end
