set :sessions => true

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