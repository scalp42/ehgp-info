require 'controllers/application_controller'

class FakturaController < ApplicationController
  get ('/faktura') do
    @mandanten = query 'select',
      '  "md_Kanton" as id',
      ', "md_Beschreibung" as name',
      ', count(*) as vertraege',
      'FROM "Mandant"',
      'left inner join "VertragMandantMitSpital" on "vt_md_ID" = "md_ID"',
      'where "vt_cd_LeMdFaktura" = 1',
      'group by "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung" asc'

    @spitaeler = query 'select "sp_ID" as id',
      ', "sp_Kanton"||\' \'||"sp_Name" as name',
      ', count ("vt_sp_ID") as vertraege',
      'from "StammSpital"',
      'left outer join "VertragMandantMitSpital" on "vt_sp_ID" = "sp_ID"',
      'where "sp_cd_LeXmlZertifiziert" = 1',
      'group by "sp_ID","sp_Kanton","sp_Name"',
      'order by name'

    slim :faktura_index
  end

  get '/faktura/kanton/:id' do |kanton|
    @kanton = select_first '"md_ID" as id',
      ', "md_Kanton" as kanton',
      ', "md_Beschreibung" as name',
      'from "Mandant"',
      'where "md_Kanton" = ', kanton.surround("'")

    @vertraege = select '"sp_ID" as id',
      ', "sp_Kanton" as kanton',
      ', "sp_Name" as name',
      ', "vt_cd_LeMdSystemkogu" as systemkogu',
      'from "StammSpital"',
      'inner join "VertragMandantMitSpital" on "vt_sp_ID" = "sp_ID"',
      'where "vt_md_ID" = ', @kanton[:id],
      'and "sp_cd_LeXmlZertifiziert" = 1'

    slim :faktura_kanton
  end

  get '/faktura/test' do
    binding.pry
  end
end
