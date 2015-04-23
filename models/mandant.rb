require 'models/base'

class Mandant < Base
  def with_vertraege_count
    query = [
      'select',
      '"md_Kanton" as id,',
      '"md_Beschreibung" as name,',
      'count(*) as count',
      'from "Mandant"',
      'inner join "VertragMandantMitSpital"',
      'on "vt_md_ID" = "md_ID"',
      'where "vt_cd_LeMdFaktura" = 1',
      'group by "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung" asc'
    ].join(' ')
    DB[query].map { |d| self.class.new(d) }
  end
end
