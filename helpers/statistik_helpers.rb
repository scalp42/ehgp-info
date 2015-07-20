module StatistikHelpers
  # fuer Statistik#index
  def stats_panel(title, text, link_path)
    slim [
      'a.list-group-item href="' + url('/statistik/' + link_path) + '"',
      '  h4.list-group-item-heading ' + title,
      '  p.list-group-item-text ' + text
    ].join("\n")
  end
end
