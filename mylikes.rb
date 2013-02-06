require 'sinatra'
require 'omniauth-facebook'

enable :sessions

#Here is the application id and secret
APP_ID = "249002731901637"
APP_SECRET = "8c6b419b892ccd25ec7ca59d60ec8bce"

SCOPE = 'email,user_likes'

use Rack::Session::Cookie

use OmniAuth::Builder do
	provider :facebook, APP_ID, APP_SECRET, :scope => SCOPE
end

get '/' do
	@articles = []
	@articles << { :title => "Deploying Rack-based apps to Heroku", :url => "http://docs.heroku.com/rack"}
	@articles << { :title => "Learn ruby in 20 minutes", :url => "http://tryruby.org"}
	erb :index
end

get '/auth/facebook/callback' do
	session['fb_auth'] = request.env['omniauth.auth']
	session['fb_token'] = session['fb_auth']['credentials']['token']
	session['fb_error'] = nil
	redirect '/'
end

get '/auth/failure' do
	clear_session
	session['fb_error'] = 'In order to use this site, you must allow us to access your Facebook data<br/>'
	redirect '/'
end

get '/logout' do
	clear_session
	redirect '/'
end

def clear_session
	session['fb_auth'] = nil
	session['fb_token'] = nil
	session['fb_error'] = nil
end
