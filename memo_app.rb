# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom' # uuid
require 'sinatra/namespace'
require_relative 'helpers/helpers.rb'
require 'byebug'

set :environment, :development

helpers Helper
namespace '/memos' do # RuBocopより、 Block has too many lines. [39/25] namespace '/memos' do ... と指摘されており未解決。
  get '' do
    @memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '/posts' do
    title, content, id = recieve_params(params[:title], params[:content], params[:id])
    memos = File.open('memos.json') { |f| JSON.parse(f.read) } # 重複を避けるために before do でまとめた場合、インスタンス変数(@memos)は増える。それが良いのか不明。
    memos['memos'] << { 'id' => id, 'title' => title, 'content' => content }
    json_dump(memos)
    validate(title, content, id) # 入力情報を検証していますが、情報は保存され /memos/:id/edit に遷移します。
    # 一度入力した情報を消さないままエラーメッセージを表示することが実現できていないため。
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
    title, content, id = recieve_params(params[:title], params[:content], params[:id])
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    edited_data = { 'id' => id, 'title' => title, 'content' => content }
    memos['memos'].map! { |memo| memo['id'] == id ? edited_data : memo }
    json_dump(memos)
    validate(title, content, id) # 入力情報を検証していますが、情報は保存され /memos/:id/edit に遷移します。
    # 一度入力した情報を消さないままエラーメッセージを表示することが実現できていないため。
  end

  delete '/del' do
    memos = File.open('memos.json') { |f| JSON.parse(f.read) }
    memo_index = memos['memos'].index { |memo| memo['id'] == escape_html(params[:id]).to_s }
    memos['memos'].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
    json_dump(memos)
    redirect '/memos'
  end
end
