require 'controllers/application_controller'

class StatistikController < ApplicationController
  helpers StatistikHelpers

  get ('/statistik') do
    slim :'statistik/index'
  end

  get('/statistik/efaktura.?:format?') do
    @rows = Statistik.efaktura.to_a
    @columns = ['Jahr', 'Monat', 'GD', 'Anz. Rechnungen']

    case format
    when 'xlsx'
      return render_xlsx(@rows, @columns, 'eFaktura', 'eFaktura-Volumen')

    when 'js'
      @labels = @rows.map { |row| '%4d-%02d' % [row[:jahr], row[:monat]] }.uniq.sort
      dataset_names = @rows.map { |row| row[:kanton] }.uniq
      @dataset = {}
      dataset_names.each do |kanton|
        @dataset[kanton] = @labels.map { |l| [l, nil] }.to_h
      end

      @rows.each do |row|
        label = '%4d-%02d' % [row[:jahr], row[:monat]]
        @dataset[row[:kanton]][label] = row[:rechnungen]
      end

      @colors = {
        'FR' => '#000000',
        'GL' => '#FFD730',
        'JU' => '#ffffff',
        'SG' => '#009933',
        'SZ' => '#E7423F',
      }

      headers 'Content-Type' => 'application/javascript'
      return erb :'statistik/efaktura.js', layout: false

    else # HTML

      slim :'statistik/efaktura'

    end
  end

  get('/statistik/aktive_le.?:format?') do
    render_stats(:aktive_le, 'Aktive-LE', format) do |sheet|
      # fix number fomats
      num = sheet.workbook.styles.add_style num_fmt: 1
      sheet.col_style 0, num, row_offset: 1
      sheet.col_style 2, num, row_offset: 1
    end
  end

  private

  def format
    @_format ||= (params[:format] || 'html')
  end

  def render_stats(name, file, format)

    # fetch data and immediately convert it to an array to
    # avoid multiple queries
    @rows = Statistik.send(name).to_a
    @cols = @columns || @rows.first.keys

    if format.eql?('xlsx')
      return render_xlsx(@rows, @cols, name, file)
    else
      # Default is HTML
      slim :"statistik/#{name}"
    end
  end

  def render_xlsx(rows, cols, name, file)
    # generate XLSX File
    p = Axlsx::Package.new
    header = p.workbook.styles.add_style b: true
    p.workbook.add_worksheet(name: name.to_s) do |sheet|
      # header row
      sheet.add_row cols, style: header

      # insert data
      rows.each { |row| sheet.add_row(row.values) }

      # call any custom code if present
      yield sheet if block_given?
    end

    filename = Date.today.strftime("#{file}_%Y-%m-%d.xlsx")
    headers \
      'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; char    set=UTF-8',
      'Content-Disposition' => "attachment; filename=#{filename}"

    p.to_stream # rack can read a stream directly
  end
end
