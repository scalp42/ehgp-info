require 'controllers/application_controller'

class StatistikController < ApplicationController
  get ('/statistik') do
    slim :'statistik/index'
  end

  get('/statistik/efaktura.?:format?') do
    @rows = Statistik.efakturas
    format = params[:format] || 'html'

    if format.eql?('csv')
      rows = @rows.to_a
      csv = [rows.first.keys.map(&:capitalize).join(';')]
      csv += rows.map { |row| row.values.join(';') }

      filename = Date.today.strftime('eFaktura_Volumen-%Y-%m-%d.csv')
      headers \
        'Content-Type' => 'text/csv; charset=utf-8',
        'Content-Disposition' => "attachment; filename=#{filename}"
      return csv.join("\n")

    else

      # Default is HTML
      slim :'statistik/efaktura'

    end
  end
end
