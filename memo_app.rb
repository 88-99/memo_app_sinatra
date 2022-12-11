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
  @memo = memos["memos"].find {|memo| memo["id"] == "#{escape_html(params[:id])}" }

  erb :show
end

get '/memos/:id/edit' do
  memos = File.open("memos.json") { |f| JSON.load(f) }
  @memo = memos["memos"].find { |memo| memo["id"] == "#{escape_html(params[:id])}" }

  erb :edit
end

patch '/memos/edit' do
  title = "#{escape_html(params[:title])}"
  content = "#{escape_html(params[:content])}"
  id = "#{escape_html(params[:id])}"

  memos = File.open("memos.json") { |f| JSON.load(f) }
  edited_data = { "id" => id, "title" => title, "content" => content }
  memos["memos"].map! { |memo| memo["id"] == id ? edited_data : memo }
  File.open("memos.json", "w") { |f| JSON.dump(memos, f) }

  redirect '/memos'
end

delete '/memos/del' do
  memos = File.open("memos.json") { |f| JSON.load(f) }
  memo_index = memos["memos"].index {|memo| memo["id"] == "#{escape_html(params[:id])}" }
  memos["memos"].delete_at(memo_index) # .destroyができなかったのでrubyでmemos[]から削除。
  File.open("memos.json", "w") { |f| JSON.dump(memos, f) }

  redirect '/memos'
end
