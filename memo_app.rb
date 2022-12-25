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
    Post.post_contents(params[:title], params[:content])
    redirect '/memos'
  end

  get '/:id' do
    @memo = Get.get_contents(params[:id])
    erb :show
  end

  get '/:id/edit' do
    @memo = Get.get_contents(params[:id])
    erb :edit
  end

  patch '' do
    Patch.patch_contents(params[:id], params[:title], params[:content])
    redirect '/memos'
  end

  delete '/:id' do
    Delete.delete_contents(params[:id])
    redirect '/memos'
  end
end
