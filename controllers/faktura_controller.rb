require 'controllers/application_controller'

class FakturaController < ApplicationController
  get '/faktura' do
    @mandanten = Mandant.with_faktura_contracts
    @spitaeler = Spital.xml_with_contracts

    @invalid = Spital.invalid

    slim :'faktura/index'
  end

  get '/faktura/kanton/:id' do |kanton|
    @kanton = Mandant.find(kanton)
    @vertraege = Vertrag.for_mandant(@kanton.id)

    slim :'faktura/kanton'
  end

  get '/faktura/spital/:id' do |id|
    id = id.to_i
    @spital = Spital.find(id)
    pass unless @spital # not found
    @vertraege = Vertrag.for_spital(id)

    slim :'faktura/spital'
  end
end
