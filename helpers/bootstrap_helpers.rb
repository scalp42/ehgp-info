module BootstrapHelpers
  # Generates a Menu link that is displayed as "active" if the link matches our
  # current location.
  #
  # @param link [String] URL to use
  # @param text [String] link text
  # @return [String]
  def menu_link(link, text, icon: nil)
    active = ' class="active"' if current_path?(link)
    icon = icon ? glyphicon(icon) : ''
    %Q{<li#{active}><a href="#{url(link)}">#{icon}#{text}</a></li>}
  end

  # Generate a Glyphicon.
  #
  # @param glyph [#to_s] The Glyph to render
  def glyphicon(glyph)
    slim %Q{span.glyphicon.glyphicon-#{glyph.to_s}> aria-hidden="true"}
  end

  # Generate a Bootstrap-Label.
  #
  # @param type [Symbol] one of `:default`, `:primary`, `:success`, `:info`,
  #   `:warning` or `:danger`.
  # @param text [String] label text
  def label(type, text)
    %Q{<span class="label label-#{type.to_s}">#{text}</span>}
  end
end
