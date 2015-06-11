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
    "#{kanton} #{name}"
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
        ', "im_Name" as intermediaer',
        'from "StammSpital"',
        'left join "Intermediaer" on "im_ID" = "sp_Intermediaer"',
        'where "sp_ID" =', id.to_i
      self.new(data)
    end

    # Alle spitaeler mit anz. vertraegen.
    def having_faktura_contracts
      results = query 'select "sp_ID" as id',
        ', "sp_Kanton" as kanton',
        ', "sp_Name" as name',
        ', "sp_Aktiv" as aktiv',
        ', "sp_cd_LeXmlZertifiziert" as zertifiziert',
        ', count ("vt_sp_ID") as vertraege',
        'from "StammSpital"',
        'left outer join "VertragMandantMitSpital" on "vt_sp_ID" = "sp_ID"',
        'where "vt_cd_LeMdFaktura" = 1',
        'group by "sp_ID","sp_Kanton", "sp_Name", "sp_Aktiv", "sp_cd_LeXmlZertifiziert"',
        'order by "sp_Kanton", "sp_Name"'
      results.map { |data| self.new(data) }
    end
  end
end
