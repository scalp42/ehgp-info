require 'controllers/application_controller'

class FakturaController < ApplicationController
  get ('/') do
    @mandanten = query 'select',
      '  "md_Kanton" as kanton',
      ', "md_Beschreibung" as beschreibung',
      ', count(*) as vertraege',
      'FROM "Mandant"',
      'left inner join "VertragMandantMitSpital" on "vt_md_ID" = "md_ID"',
      'where "vt_cd_LeMdFaktura" = 1',
      'group by "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung" asc'

    slim :faktura_index
  end
end
