# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom' # uuid
require 'sinatra/namespace'
require_relative 'memo'
require 'byebug'
require 'debug'

set :environment, :development

# def json_to_ruby
#   File.open('memos.json') { |f| JSON.parse(f.read) }
# end

def write_file(memos)
  File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
end

def show_memo
  memos = json_to_ruby
  @memo = memos['memos'].find { |memo| memo['id'] == params[:id] }
end

namespace '/memos' do
  get '' do
    @memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    # @memos = json_to_ruby
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '' do
    id = SecureRandom.uuid
    memo = Memo.new(params[:title], params[:content])
    memo.json_to_ruby << { id:, title: memo.title, content: memo.content }
    # memos['memos'] << { id:, title: memo.title, content: memo.content }
    write_file(memos)
    redirect '/memos'
  end

  get '/:id' do
    show_memo
    erb :show
  end

  get '/:id/edit' do
    show_memo
    erb :edit
  end

  patch '' do
    memos = json_to_ruby
    edited_data = { id: params[:id], title: params[:title], content: params[:content] }
    @memo = memos['memos'].map! { |memo| memo['id'] == params[:id] ? edited_data : memo }
    write_file(memos)
    redirect '/memos'
  end

  delete '/:id' do
    memos = json_to_ruby
    memo_index = memos['memos'].index { |memo| memo['id'] == params[:id] }
    memos['memos'].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
    write_file(memos)
    redirect '/memos'
  end
end
