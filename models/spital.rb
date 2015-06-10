require 'models/base'

class Spital < Base
  extend DatabaseHelpers

  def aktiv?
    aktiv < 50
  end

  def self.find(id)
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
end
