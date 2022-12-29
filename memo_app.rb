# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require_relative 'memo'

set :environment, :development

namespace '/memos' do
  get '' do
    @memos = Memo.index
    erb :index
  end

  get '/new' do
    erb :new
  end

  post '' do
    Memo.new(nil, params[:title], params[:content]).create
    redirect '/memos'
  end

  get '/:id' do
    @memo = Memo.show_memo(params[:id])
    erb :show
  end

  get '/:id/edit' do
    @memo = Memo.show_memo(params[:id])
    erb :edit
  end

  patch '' do
    @memo = Memo.new(params[:id], params[:title], params[:content])
    @memo.update
    redirect '/memos'
  end

  delete '/:id' do
    Memo.show_memo(params[:id]).delete
    redirect '/memos'
  end
end
