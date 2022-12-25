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

namespace '/memos' do
  get '' do
    @memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '' do
    id = SecureRandom.uuid
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memos['memos'] << { id:, title: params[:title], content: params[:content] }
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
    redirect '/memos'
  end

  get '/:id' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    @memo = memos['memos'].find { |memo| memo['id'] == params[:id] }
    erb :show
  end

  get '/:id/edit' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    @memo = memos['memos'].find { |memo| memo['id'] == params[:id] }
    erb :edit
  end

  patch '' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    edited_data = { id: params[:id], title: params[:title], content: params[:content] }
    @memo = memos['memos'].map! { |memo| memo['id'] == params[:id] ? edited_data : memo }
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
    redirect '/memos'
  end

  delete '/:id' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memo_index = memos['memos'].index { |memo| memo['id'] == params[:id] }
    memos['memos'].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
    File.open('memos.json', 'w') { |f| JSON.dump(memos, f) }
    redirect '/memos'
  end
end
