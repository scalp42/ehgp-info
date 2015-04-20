module ApplicationHelpers
  # Checks whether we are on the given path
  #
  # @param path [String] the path to check
  # @return [Boolean] whether or not we are on +path+
  def current_path?(path)
    path = '/' + path.gsub(/^\/+/, '')
    request.path.start_with?(path)
  end

  # Generates a Menu link that is displayed as "active" if the link matches our
  # current location.
  #
  # @param link [String] URL to use
  # @param text [String] link text
  # @return [String]
  def menu_link(link, text)
    link = url(link)
    active = ' class="active"' if current_path?(link)
    %Q{<li#{active}><a href="#{link}">#{text}</a></li>}
  end
end
