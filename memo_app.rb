# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require_relative 'memo'

set :environment, :development

def connect_db
  PG.connect(dbname: 'memo')
end
conn = connect_db

# rubocop:disable Metrics/BlockLength
namespace '/memos' do
  get '' do
    @memos = Memo.index(conn)
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '' do
    Memo.new(nil, params[:title], params[:content]).create(conn)
    redirect '/memos'
  end

  get '/:id' do
    @memo = Memo.show_memo(conn, params[:id])
    erb :show
  end

  get '/:id/edit' do
    @memo = Memo.show_memo(conn, params[:id])
    erb :edit
  end

  patch '' do
    @memo = Memo.new(params[:id], params[:title], params[:content]).update(conn)
    redirect '/memos'
  end

  delete '/:id' do
    Memo.delete(conn, params[:id])
    redirect '/memos'
  end
end
# rubocop:enable Metrics/BlockLength
