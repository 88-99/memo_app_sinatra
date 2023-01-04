# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'pg'

class Memo
  attr_accessor :id, :title, :content

  def initialize(id, title, content)
    @id = id.nil? ? SecureRandom.uuid : id
    @title = title
    @content = content
  end

  def self.index(conn)
    memos = conn.exec('SELECT * FROM memos')
    memos.map { |memo| Memo.new(memo['id'], memo['title'], memo['content']) }
  end

  def create(conn)
    conn.exec('INSERT INTO memos VALUES ($1, $2, $3)', [@id, @title, @content])
  end

  def update(conn)
    conn.exec("UPDATE memos SET title = $1, content = $2 WHERE id = $3", [@title, @content, @id])
  end

  def self.delete(conn, id)
    conn.exec('DELETE FROM memos WHERE id = $1',[id]).first
  end

  def self.show_memo(conn, id)
    memo = conn.exec('SELECT * FROM memos WHERE id = $1',[id]).first
    Memo.new(memo['id'], memo['title'], memo['content'])
  end
end
