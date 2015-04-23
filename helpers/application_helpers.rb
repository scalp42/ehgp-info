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
end
