set :sessions => true

helpers do
  
  # this method checks to make sure the user is signed in and also checks
  # their authorization level vs. the parameter minimum_level
  # if a locations_involved parameter is passed, it makes sure the user
  # involved is the owner of the location to or from the product is being
  # moved.  Also includes optional error message if not authorized
  # minimum_level - INTEGER - minimum authorization level to access this erb
  # erb_destination - SYMBOL - if authorized, user is sent here
  # locations_involved(optional) - ARRAY - location_ids of the location a 
  #    product is being moved from and to
  # not_authorized_messaged(optional) - message to be displayed if user
  #    is not authorized
  # returns erb if authorized OR failure text if not authorized
  def authorize(minimum_level, erb_destination, locations_involved: nil, not_authorized_message: nil)
    authorized = false
    
    if @user
      binding.pry
      if @user.auth_level >= minimum_level
        binding.pry
        authorized = true
        binding.pry
      elsif locations_involved.includes?(@user.location_owned)
        binding.pry
        authorized = true
      end
    end
  
  if authorized == true
    erb erb_destination
  elsif authorized == false
    return not_authorized_message || "Not Authorized :("
  end
end
end

before do
  if !session["user_id"]
    erb :"/user/login"
  else
    @user = User.find(session["user_id"])
  end
end

get "/logout" do
  session["user_id"] = nil
  erb :"/menu"
end

get "/add_new_user" do
  erb :"/user/add_user_form"
end

get "/add_user_confirm" do
  password = BCrypt::Password.create(params["new_user"]["password"])
  @new_user = User.add({"email" => params["new_user"]["email"], "password" => password, "auth_level" => params["new_user"]["auth_level"], "location_owned" => params["new_user"]["location_owned"]})
  erb :"/menu"
end

get "/see_all_users" do
    erb :"/user/see_all_users"
end

get "/login" do
  erb :"/user/login"
end

get "/login_confirm" do
  user_info = User.get_user_for_login(params["login"]["email"])
  if user_info
    if user_info.correct_password?(params["login"]["password"])
      session["user_id"] = user_info.id
      erb :"/menu"
    else
      @error = "Invalid log in.  Please try again"
      erb :"/user/login"
    end
  else
    @error = "Invalid log in.  Please try again"
    erb :"/user/login"
  end
end