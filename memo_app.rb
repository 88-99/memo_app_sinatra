# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom' # uuid
require 'sinatra/namespace'
require_relative 'helpers/helpers'
require 'byebug'

set :environment, :development

helpers Helper
namespace '/memos' do
  get '' do
    @memos = read_file
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '' do
    title, content, id = recieve_params(params[:title], params[:content], params[:id])
    memos = read_file
    memos['memos'] << { id:, title:, content: }
    json_dump(memos)
    if validate(title, content)
      redirect "/memos/#{id}/edit" # 入力情報を検証していますが、情報は保存され /memos/:id/edit に遷移します。
    else                           # 一度入力した情報を消さないままエラーメッセージを表示することが実現できていないため。
      redirect '/memos'
    end
  end

  get '/:id' do
    memos = read_file
    @memo = memos['memos'].find { |memo| memo['id'] == params[:id] }
    erb :show
  end

  get '/:id/edit' do
    memos = read_file
    @memo = memos['memos'].find { |memo| memo['id'] == params[:id] }
    erb :edit
  end

  patch '' do
    title, content, id = recieve_params(params[:title], params[:content], params[:id])
    memos = read_file
    edited_data = { id:, title:, content: }
    memos['memos'].map! { |memo| memo['id'] == id ? edited_data : memo }
    json_dump(memos)
    if validate(title, content)
      redirect "/memos/#{id}/edit" # 入力情報を検証していますが、情報は保存され /memos/:id/edit に遷移します。
    else                           # 一度入力した情報を消さないままエラーメッセージを表示することが実現できていないため。
      redirect '/memos'
    end
  end

  delete '/:id' do
    memos = read_file
    memo_index = memos['memos'].index { |memo| memo['id'] == params[:id] }
    memos['memos'].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
    json_dump(memos)
    redirect '/memos'
  end
end
