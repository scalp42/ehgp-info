require 'controllers/application_controller'

class ReferenztarifeController < ApplicationController
  get('/referenztarife') do
    @kantone = Mandant.with_reference_tarif
    slim :'referenztarife/index'
  end

  get('/referenztarife/:kanton') do
    @mandant = Mandant.find(params['kanton'])
    @tarife = Referenztarif.for(@mandant.id)
    slim :'referenztarife/show'
  end
end
