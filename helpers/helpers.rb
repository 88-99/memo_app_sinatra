# frozen_string_literal: true

module Helper
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end

  def recieve_params(title, content, id)
    id = id.nil? ? SecureRandom.uuid : id
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
