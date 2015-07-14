module ApplicationHelpers
  # Checks whether we are on the given path
  #
  # @param path [String] the path to check
  # @return [Boolean] whether or not we are on +path+
  def current_path?(path)
    path = '/' + path.gsub(/^\/+/, '')
    request.path_info.start_with?(path)
  end

  # Bringt eine Person in die Mehrzahl, ausser +count+ ist 1.
  #
  # @param count [#to_i]
  # @param singular [String] Einzahl
  # @param plural [String] Mehrzahl
  def pluralize(count, singular, plural)
    count = count.to_i
    word = count == 1 ? singular : plural
    "#{count} #{word}"
  end

  # Zeigt ein Label an, dass anzeigt ob ein Spital KoGus
  # einreichen muss, oder ob automatisch Systemkogus
  # angelegt werden.
  #
  # @param [#to_i] systemkogu Ob automatisch Systemkogus erstellt werden oder nicht
  def systemkogu_label(systemkogu)
    if systemkogu.to_i == 0
     label :success, 'Spital muss KoGu einreichen'
    else
      label :danger, 'Es werden automatisch Systemkogus erstellt'
    end
  end

  # Zeigt ein Label an, das anzeigt ob ein Spital eFaktura-
  # zertifiziert ist oder nicht
  #
  # @param [Boolean] zertifiziert
  def zertifiziert_label(zertifiziert)
    if zertifiziert
      label :success, 'Spital ist zertifiziert!'
    else
      label :danger, 'Spital ist NICHT zertifiziert!'
    end
  end

  # Zeigt ein Label an, das anzeigt ob ein LE aktiv ist oder nicht.
  #
  # @param [Boolean] aktiv
  def aktiv_label(aktiv)
    if aktiv
      label :success, 'Spital ist aktiv!'
    else
      label :danger, 'Spital ist NICHT aktiv!'
    end
  end

  def list_group_item_spital(spital)
    css = (spital.aktiv? && spital.zertifiziert?) ? '' : '.list-group-item-danger'
    url = url("/faktura/spital/#{spital.id}")
    out = [
      %Q{a.list-group-item#{css} href="#{url}"},
      "  #{spital.bezeichnung}",
      "  span.badge #{pluralize(spital.vertraege, 'Vertrag', 'Vertr&auml;ge')}"
    ].join("\n")
    slim out
  end

  # Erzeugt einen Link mit dem angegebenen +text+ zu der angegebenen +url+.
  def link_to(text, url)
    '<a href="%s">%s</a>' % [url(url), text]
  end

  # Rendert ein Panel wie auf der Titelseite
  def home_panel(title, text, link_path, link_text = nil)
    link_text = title if link_text.nil?
    slim(:'_home_panel', locals: {
      title: title,
      text: text,
      link_path: link_path,
      link_text: link_text
    })
  end
end
