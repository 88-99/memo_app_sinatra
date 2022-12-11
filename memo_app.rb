require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom' # uuid

set :environment, :development

get '/memos' do
  @memos = File.open("memos.json") { |f| JSON.load(f) }

  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos/posts' do
  title = "#{escape_html(params[:title])}"
  content = "#{escape_html(params[:content])}"
  id = SecureRandom.uuid

  memos = File.open("memos.json") { |f| JSON.load(f) }
  memos["memos"] << { "id" => id, "title" => title, "content" => content }
  File.open("memos.json", "w") { |f| JSON.dump(memos, f) }

  redirect '/memos'
end

get '/memos/:id' do
  memos = File.open("memos.json") { |f| JSON.load(f) }
  @memo = memos["memos"].find {|memo| memo["id"] == "#{params[:id]}" }

  erb :show
end