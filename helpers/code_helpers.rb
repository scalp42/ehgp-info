module CodeHelpers
  # Outputs a Panel with the given +title+ and a table containing
  # the codes and descriptions of the given code +type+
  def code_table(title, type)
    # Codetypes only contain letters, underscores and dashes
    type.gsub!(/[^a-zA-Z_-]/, '')
    codes = select '"cd_ID" as id',
      ', "cd_Beschreibung" as text',
      'from "ISCode"',
      %Q{where "cd_Typ" = '#{type}'},
      'order by "cd_Sort" asc'

    slim :'codes/_table', locals: { title: title, codes: codes }
  end
end
