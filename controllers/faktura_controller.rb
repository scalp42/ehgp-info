require 'controllers/application_controller'

class FakturaController < ApplicationController
  get ('/faktura') do
    @mandanten = Mandant.with_faktura_contracts
    @spitaeler = Spital.having_faktura_contracts

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
      'and "vt_cd_LeMdFaktura" = 1',
      'and "sp_cd_LeXmlZertifiziert" = 1',
      'order by "sp_Kanton" asc, "sp_Name" asc'

    slim :faktura_kanton
  end

  get '/faktura/spital/:id' do |id|
    id = id.to_i
    @spital = Spital.find(id)
    @vertraege = select '"md_Kanton" as kanton',
      ', "md_Beschreibung" as beschreibung',
      ', "vt_cd_LeMdSystemkogu" as systemkogu',
      'from "Mandant"',
      'inner join "VertragMandantMitSpital" on "vt_md_ID" = "md_ID"',
      'where "vt_sp_ID" = ', id,
      'and "vt_cd_LeMdFaktura" = 1',
      'order by "md_Beschreibung" asc'

    slim :faktura_spital
  end

  get '/faktura/test' do
    binding.pry
  end
end
