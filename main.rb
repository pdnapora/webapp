require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do
  def calculate_total(cards)
    arr = cards.map{|element| element[1]}

    total = 0
    arr.each do |a|
      if a == 'a'
        total += 11
      else
        total += a.to_i == 0 ? 10 : a.to_i
      end
    end

    # correct for aces
    arr.select{|element| element == 'a'}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end

before do
  @show_button_flag = true
end

# make sure that we have a username set
get '/' do
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

post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
  if calculate_total(session[:player_cards]) > 21
    @error = session[:player_name].to_s + " busts! better luck next time..."
    @show_button_flag = false
  end

  erb :game
end

post '/game/player/stay' do
  @success = session[:player_name].to_s + " stays."
  @show_button_flag = false
  erb :game
end
