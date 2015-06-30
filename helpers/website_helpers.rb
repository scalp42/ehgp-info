module WebsiteHelpers
  # Helpers for Update News
  def update(date, &block)
    slim :'website/_update', locals: {date: date}, &block
  end

  def added(text)
    slim ['li.text-success', glyphicon(:'plus-sign'), text.to_s].join(' ')
  end

  def fixed(text)
    slim ['li.text-danger', glyphicon(:'ok-sign'), text.to_s].join(' ')
  end
  
  def modified(text)
    slim ['li.text-warning', glyphicon(:'minus-sign'), text.to_s].join(' ')
  end
end
