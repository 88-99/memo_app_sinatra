class Memo
  attr_accessor :title, :content
  def initialize(title, content)
    @title = title
    @content = content
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
  end

end

