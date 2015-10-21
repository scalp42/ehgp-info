require 'models/base'

class Referenztarif < Base
  extend DatabaseHelpers

  def self.for(mandant_id)
    results = select '"rt_GueltigAb" as gueltig_ab',
      ', "rt_GueltigBis" as gueltig_bis',
      ', "rt_Typ" as typ',
      ', "rt_Aktiv" as aktiv',
      ', "rt_Betrag" as betrag',
      ', "ct_Text" as text',
      'from KOGU."Referenztarif"',
      'join KOGU."ISCodeText" on "ct_ID" = "rt_ReferenzCd"',
      'where "rt_Mandant" =', mandant_id.to_i,
      'and "ct_Sprache" = \'DE\'',
      'order by "rt_Sort" asc, "rt_GueltigAb" desc, "ct_Text" desc'
    results.map { |data| self.new(data) }
  end
end
