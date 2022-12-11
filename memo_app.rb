# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom' # uuid
require 'sinatra/namespace'

set :environment, :development

namespace '/memos' do
  get '' do
    @memos = File.open('memos.json') { |f| JSON.parse(f.read) }

    erb :index
  end

  get '/new' do
    erb :new
  end

  post '/posts' do
    title = escape_html(params[:title]).to_s
    content = escape_html(params[:content]).to_s
    id = SecureRandom.uuid

    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memos['memos'] << { 'id' => id, 'title' => title, 'content' => content }
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }

    redirect '/memos'
  end

  get '/:id' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    @memo = memos['memos'].find { |memo| memo['id'] == escape_html(params[:id]).to_s }

    erb :show
  end

  get '/:id/edit' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    @memo = memos['memos'].find { |memo| memo['id'] == escape_html(params[:id]).to_s }

    erb :edit
  end

  patch '/edit' do
    title = escape_html(params[:title]).to_s
    content = escape_html(params[:content]).to_s
    id = escape_html(params[:id]).to_s

    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    edited_data = { 'id' => id, 'title' => title, 'content' => content }
    memos['memos'].map! { |memo| memo['id'] == id ? edited_data : memo }
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }

    redirect '/memos'
  end

  delete '/del' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memo_index = memos['memos'].index { |memo| memo['id'] == escape_html(params[:id]).to_s }
    memos['memos'].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }

    redirect '/memos'
  end
end
