require 'controllers/application_controller'

class ReferenztarifeController < ApplicationController
  get('/referenztarife') do
    @kantone = select '"md_Kanton" as id',
                    ', "md_Beschreibung" as name',
                    ', count("rt_ReferenzCd") as tarife',
      'from "Mandant"',
      'inner join "Referenztarif" on "md_ID" = "rt_Mandant"',
      'group by "md_Kanton", "md_Beschreibung"',
      'order by "md_Beschreibung"'

    slim :'referenztarife/index'
  end

  get('/referenztarife/:kanton') do
    @mandant = Mandant.find(params['kanton'])
    @tarife = Referenztarif.for(@mandant.id)
    slim :'referenztarife/show'
  end
end
