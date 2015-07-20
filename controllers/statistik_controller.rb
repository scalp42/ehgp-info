require 'controllers/application_controller'

class StatistikController < ApplicationController
  helpers StatistikHelpers

  get ('/statistik') do
    slim :'statistik/index'
  end

  get('/statistik/efaktura.?:format?') do
    @columns = ['Jahr', 'Monat', 'GD', 'Anz. Rechnungen']
    render_stats(:efaktura, 'eFaktura-Volumen', format)
  end

  get('/statistik/aktive_le.?:format?') do
    render_stats(:aktive_le, 'Aktive-LE', format) do |sheet|
      # fix number fomats
      num = sheet.workbook.styles.add_style num_fmt: 1
      sheet.col_style 0, num, row_offset: 1
      sheet.col_style 2, num, row_offset: 1
    end
  end

  get('/statistik/top_le.?:format?') do
    from = get_date(params[:from])
    to = get_date(params[:to]) || Date.today.strftime('%Y-%m-%d')

    if from.nil?
      return slim :'statistik/top_le'
    end

    @data = Statistik.top_le(from, to)
  end

  private

  def get_date(input)
    if input =~ /\d\d\d\d-\d\d-\d\d/
      input
    end
  end

  def format
    @_format ||= (params[:format] || 'html')
  end

  def render_stats(name, file, format)

    # fetch data and immediately convert it to an array to
    # avoid multiple queries
    @rows = Statistik.send(name).to_a
    @cols = @columns || @rows.first.keys

    if format.eql?('xlsx')

      # generate XLSX File
      p = Axlsx::Package.new
      header = p.workbook.styles.add_style b: true
      p.workbook.add_worksheet(name: name.to_s) do |sheet|
        # header row
        sheet.add_row @cols, style: header

        # insert data
        @rows.each { |row| sheet.add_row(row.values) }

        # call any custom code if present
        yield sheet if block_given?
      end

      filename = Date.today.strftime("#{file}_%Y-%m-%d.xlsx")
      headers \
        'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; char    set=UTF-8',
        'Content-Disposition' => "attachment; filename=#{filename}"

      return p.to_stream # rack can read a stream directly

    else

      # Default is HTML
      slim :"statistik/#{name}"

    end
  end
end
