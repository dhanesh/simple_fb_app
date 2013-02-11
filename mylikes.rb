APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

require 'rubygems'
require 'sinatra'
require 'koala'
require 'yaml'

include Koala

enable :sessions

SITE_URL = 'http://localhost:4567/'

#Here is the application id and secret
APP_ID = 414082215348551
APP_SECRET = "50029ee89725c434ae9ea57030698fb0"

SCOPE = ['email','user_likes']

set :root, APP_ROOT

use Rack::Session::Cookie, secret: 'BettyButterBoughtSomeButter'

get '/' do
	if session['access_token']
		@graph = Facebook::API.new(session['access_token'])
		@profile = @graph.get_object('me')
		@likes = @graph.get_connection("me", "likes")
		erb :index
	else
		erb :index
	end
end


get '/login' do
	session['oauth'] = Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + 'callback')

	redirect session['oauth'].url_for_oauth_code(:permissions => SCOPE)
end

get '/logout' do
	session['oauth'] = nil
	session['access_token'] = nil
	redirect '/'
end

get '/callback' do
	session['access_token'] = session['oauth'].get_access_token(params[:code])
	redirect '/'
end