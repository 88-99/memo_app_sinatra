# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'pg'

class Memo
  attr_accessor :id, :title, :content

  def initialize(id, title, content)
    @id = id
    @title = title
    @content = content
  end

  def self.index(conn)
    memos = conn.exec('SELECT * FROM memos')
    memos.map { |memo| Memo.new(memo['id'], memo['title'], memo['content']) }
  end

  def self.create(conn, title, content)
    conn.exec_params('INSERT INTO memos VALUES ($1, $2, $3)', [SecureRandom.uuid, title, content])
  end

  def self.update(conn, title, content, id)
    conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def self.delete(conn, id)
    conn.exec_params('DELETE FROM memos WHERE id = $1', [id]).first
  end

  def self.show_memo(conn, id)
    memo = conn.exec_params('SELECT * FROM memos WHERE id = $1', [id]).first
    Memo.new(memo['id'], memo['title'], memo['content'])
  end
end
