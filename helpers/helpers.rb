module Helper
  def escape_html
    Rack::Utils.escape_html(text)
  end

  def recieve_params(title, content, id)
    title = escape_html(title).to_s
    content = escape_html(content).to_s
    id = id.nil? ? SecureRandom.uuid : escape_html(id).to_s
    [title, content, id]
  end

  def validate(title, content, id)
    if [title, content].any?(&:empty?) || title.length > 30 || content.length > 1000
      # (title || content).empty? では、(title = "123") && (content = "")でfalseになり機能しない。
      redirect "/memos/#{id}/edit"
    else
      redirect '/memos'
    end
  end

  def json_dump(memos)
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end
end
