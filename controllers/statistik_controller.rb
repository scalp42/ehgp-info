require 'controllers/application_controller'

class StatistikController < ApplicationController
  get ('/statistik') do
    slim :'statistik/index'
  end

  get('/statistik/efaktura.?:format?') do
    @rows = Statistik.efakturas
    format = params[:format] || 'html'

    if format.eql?('csv')
      return render_csv(@rows, 'eFaktura-Volumen')
    else
      # Default is HTML
      slim :'statistik/efaktura'
    end
  end

  get('/statistik/aktive_le.?:format?') do
    @rows = Statistik.aktive_le
    @keys = @rows.first.keys
    format = params[:format] || 'html'

    if format.eql?('csv')
      return render_csv(@rows, 'AktiveLE')
    else
      # Default is HTML
      slim :'statistik/aktive_le'
    end
  end

  private

  def render_csv(data, name)
    rows = data.to_a
    keys = rows.first.keys
    # generate Headers
    csv = [keys.join(';')]
    # generate data
    csv += rows.map do |row|
      keys.map do |k|
        val = row[k]
        case
        when val.nil?
          ''
        when val.respond_to?(:encode)
          # replace newline and CR
          val.gsub(/[\s;]+/, ' ')
        else
          val
        end
      end.join(';')
    end

    # set headers
    filename = Date.today.strftime("#{name}_%Y-%m-%d.csv")
    headers \
      'Content-Type' => 'text/csv; charset=iso-8859-15',
      'Content-Disposition' => "attachment; filename=#{filename}"

    csv.join("\n").encode('iso-8859-15')
  end
end
