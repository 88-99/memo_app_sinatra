# frozen_string_literal: true

require 'json'
require 'securerandom'

class Memo
  attr_accessor :id, :title, :content

  def initialize(id, title, content)
    @id = id.nil? ? SecureRandom.uuid : id
    @title = title
    @content = content
  end

  def self.index
    memos = Memo.json_to_ruby
    memos['memos'].map { |memo| Memo.new(memo['id'], memo['title'], memo['content']) }
  end

  def create
    memos = Memo.json_to_ruby
    memos['memos'] << { id: @id, title: @title, content: @content }
    write_file(memos)
  end

  def update
    memos = Memo.json_to_ruby
    edited_data = { id: @id, title: @title, content: @content }
    memos['memos'].map! { |memo| memo['id'] == @id ? edited_data : memo }
    write_file(memos)
  end

  def delete
    memos = Memo.json_to_ruby
    memo_index = memos['memos'].index { |memo| memo['id'] == @id }
    memos['memos'].delete_at(memo_index)
    write_file(memos)
  end

  def self.json_to_ruby
    File.open('memos.json') { |f| JSON.parse(f.read) }
  end

  def write_file(memos)
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
  end

  def self.show_memo(id)
    memos = Memo.json_to_ruby
    memo = memos['memos'].find { |m| m['id'] == id }
    Memo.new(memo['id'], memo['title'], memo['content'])
  end
end
