set :sessions => true

before do
  if session["user_id"] == nil
    erb :"/user/login"
  else
    @user = User.find(session["user_id"])
  end
end

get "/logout" do
  session["user_id"] = nil
  erb :"/home"
end

get "/add_new_user" do
  erb :"/user/add_user_form"
end

get "/add_user_confirm" do
  @new_user = User.add({"email" => params["new_user"]["email"], "password" => params["new_user"]["password"], "auth_level" => params["new_user"]["auth_level"], "location_owned" => params["new_user"]["location_owned"]})
  erb :"/menu"
end

get "/see_all_users" do
  erb :"/user/see_all_users"
end

get "/login" do
  erb :"/user/login"
end