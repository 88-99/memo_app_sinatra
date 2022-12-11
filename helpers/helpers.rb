module Helper
  def escape_html
    Rack::Utils.escape_html(text)
  end
end
