# frozen_string_literal: true

module Helper
  def recieve_params(title, content, id)
    id = id.nil? ? SecureRandom.uuid : id
    [title, content, id]
  end

  def validate(title, content)
    if [title, content].any?(&:empty?) || title.length > 30 || content.length > 1000
      true
    else
      false
    end
  end

  def read_file
    File.open('memos.json') { |f| JSON.parse(f.read) }
  end

  def json_dump(memos)
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end
end
