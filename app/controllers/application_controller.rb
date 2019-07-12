class ApplicationController < Sinatra::Base 
  register Sinatra::ActiveRecordExtension

  configure do
  	set :views, "app/views"
    set :public_dir, "public"
    #enables sessions as per Sinatra's docs. Session_secret is meant to encript the session id so that users cannot create a fake session_id to hack into your site without logging in. 
    enable :sessions
    set :session_secret, "secret"
  end

  # Renders the home or index page
  get '/' do
    erb :'/design/guest_home'
  end

  # Renders the sign up/registration page in app/views/registrations/signup.erb
  get '/registrations/signup' do
    erb :'/registrations/signup', layout: :signup_template
  end

  # Handles the POST request when user submits the Sign Up form. Get user info from the params hash, creates a new user, signs them in, redirects them. 
  post '/registrations' do
    @user = User.new(name: params["name"], email: params["email"])
    @user.password = params["password_digest"]
    @user.save
    session[:user_id] = @user.id
    redirect "/users/homepage"
  end

  get '/users/homepage' do
    @user = User.find_by(email: params["email"])
    erb :"/users/homepage"
  end
  
  # Renders the view page in app/views/sessions/login.erb
  get '/sessions/login' do
   erb :'sessions/login', layout: :signup_template
  end

  # Handles the POST request when user submites the Log In form. Similar to above, but without the new user creation.
  post '/sessions' do
      @user = User.find_by(email: params["email"])
      if @user.password == (params["password_digest"])
        session[:user_id] = @user.id
        
        redirect '/users/homepage'
      else 
        redirect '/sessions/login'
      end
  end

  # Logs the user out by clearing the sessions hash. 
  post '/sessions/logout' do
    session.clear
    redirect '/'
  end
  get '/get_url' do 
    erb :'/design/guest_home'
  end

  post '/get_url' do
  if params["link"] =~ URI::regexp(%w[http https])
    $base = "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ".split("")
    if session[:user_id]
      @user = User.find(session[:user_id])
      @given_url = Url.create(link: params["link"], user_id: @user.id, counter: 0)
      @given_link = @given_url.link
    else
      @given_url = Url.create(link: params["link"])
      @given_link = @given_url.link
    end
    @generateds_array = Array.new
    Url.all.each do |generated_object|
      @generateds_array << generated_object.link
    end
    @generated_url = $base.sample(7).join
    if @generateds_array.exclude?(@generated_url)
      @given_url.update(generated_link: "#{@generated_url}")
    else
      while @generateds_array.include?(@generated_url)
        @generated_url = $base.sample(7).join
      end
      @given_url.update(generated_link: "#{@generated_url}")
    end
    redirect "/get_url/#{@given_url.id}"
    else
      redirect "/"
    end
    
  end

  get '/get_url/:id' do
    if session[:user_id]
      @user = User.find(session[:user_id])  
      @link = Url.find(params["id"]).generated_link
      @direction = Url.find(params["id"]).link
      erb :"/show_url" 
    else
      @link = Url.find(params["id"]).generated_link
      @direction = Url.find(params["id"]).link
      erb :"/guest_showpage" 
    end
  end

  get "/:id" do
    if session[:user_id]
      @direct = Url.find_by(generated_link: params["id"]).link
      @current_url = Url.find_by(generated_link: params["id"])
      @current_url.counter += 1
      @current_url.save
      redirect "#{@direct}"
    else
      @direct = Url.find_by(generated_link: params["id"]).link
      redirect "#{@direct}"
    end
  end

end

  