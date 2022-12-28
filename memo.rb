class Memo
  attr_accessor :title, :content
  def initialize(title, content)
    @title = title
    @content = content
  end

  def post_contents
    id = SecureRandom.uuid
    memos = json_to_ruby
    memos['memos'] << { id:, title: @title, content: @content }
    write_file(memos)
  end

  def json_to_ruby
    File.open('memos.json') { |f| JSON.parse(f.read) }
  end

  def write_file(memos)
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end

  # def show_memo
  #   memos = json_to_ruby
  #   @memo = memos['memos'].find { |memo| memo['id'] == params[:id] }
  # end
end
