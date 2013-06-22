require 'rubygems'
require 'sinatra'

set :sessions, true

get '/form' do
  erb :form
end


# make sure that we have a username set
get '/' do
  # params['username'] = 'freddie'
  if session[:player_name]
    redirect '/game'
  else
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  session[:player_name] = params[:player_name]
  redirect '/game'
end

# set up initial gameplay
get '/game' do
  suites = %w[c h d s]
  face_values = %w[2 3 4 5 6 7 8 9 10 j q k a]
  session[:deck] = suites.product(face_values).shuffle!

  session[:dealer_cards] = []
  session[:player_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop

  erb :game
end

get '/quit' do
  erb :quit
end

post '/hit' do
  'TODO: code to execute when player "hits"'
end

post '/stay' do
  'TODO: code to execute when player "stays"'
end
