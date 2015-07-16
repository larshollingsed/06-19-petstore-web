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
    # sets authorized to false to be checked at the end
    authorized = false
    
    # checks to see if the browser is logged in
    if @user
      
      # checks to see if the authorization level of the user is greater than
      # the minimum level passed in in the parameters
      if @user.auth_level >= minimum_level
        # if true then authorized is set to true
        authorized = true
        
      # checks to see if the user owns one of the locations involved
      # optional parameter if the route involves transfer of products
      elsif locations_involved.includes?(@user.location_owned)
        # if true then sets authorized to true
        authorized = true
      end
    end
    
    # if authorized is true then sends the browser to the authorized destination
    if authorized == true
      erb erb_destination
      
    # if authorized is false then displays a default message or a more specific
    # message passed in as an option parameter
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