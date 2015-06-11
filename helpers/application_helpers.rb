module ApplicationHelpers
  # Checks whether we are on the given path
  #
  # @param path [String] the path to check
  # @return [Boolean] whether or not we are on +path+
  def current_path?(path)
    path = '/' + path.gsub(/^\/+/, '')
    request.path_info.start_with?(path)
  end

  # Generates a Menu link that is displayed as "active" if the link matches our
  # current location.
  #
  # @param link [String] URL to use
  # @param text [String] link text
  # @return [String]
  def menu_link(link, text)
    active = ' class="active"' if current_path?(link)
    %Q{<li#{active}><a href="#{url(link)}">#{text}</a></li>}
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
      slim 'span.label.label-success Spital muss KoGu einreichen'
    else
      slim 'span.label.label-danger Es werden automatisch Systemkogus erstellt'
    end
  end

  # Zeigt ein Label an, das anzeigt ob ein Spital eFaktura-
  # zertifiziert ist oder nicht
  #
  # @param [Boolean] zertifiziert
  def zertifiziert_label(zertifiziert)
    if zertifiziert
      slim 'span.label.label-success Spital ist zertifiziert!'
    else
      slim 'span.label.label-danger Spital ist NICHT zertifiziert!'
    end
  end

  # Zeigt ein Label an, das anzeigt ob ein LE aktiv ist oder nicht.
  #
  # @param [Boolean] aktiv
  def aktiv_label(aktiv)
    if aktiv
      slim 'span.label.label-success Spital ist aktiv!'
    else
      slim 'span.label.label-danger Spital ist NICHT aktiv!'
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
end
