module CodeHelpers
  # Outputs a Panel with the given +title+ and a table containing
  # the codes and descriptions of the given code +type+
  def code_table(title, type)
    # Codetypes only contain letters, underscores and dashes
    type.gsub!(/[^a-zA-Z_-]/, '')

    slim :'codes/_table', locals: { title: title, codes: Code.by_type(type) }
  end
end
