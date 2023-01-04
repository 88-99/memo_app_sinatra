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

  def self.index
    connection = PG.connect(dbname: 'memo')
    memos = connection.exec('SELECT * FROM memos')
    memos.map { |memo| Memo.new(memo['id'], memo['title'], memo['content']) }
  end

  def create
    connection = PG.connect(dbname: 'memo')
    connection.exec('INSERT INTO memos VALUES ($1, $2, $3)', [@id, @title, @content])
  end

  def update
    connection = PG.connect(dbname: 'memo')
    connection.exec("UPDATE memos SET title = $1, content = $2 WHERE id = $3", [@title, @content, @id])
  end

  def self.delete(id)
    connection = PG.connect(dbname: 'memo')
    connection.exec('DELETE FROM memos WHERE id = $1',[id]).first
  end

  def self.show_memo(id)
    connection = PG.connect(dbname: 'memo')
    memo = connection.exec('SELECT * FROM memos WHERE id = $1',[id]).first
    Memo.new(memo['id'], memo['title'], memo['content'])
  end
end
