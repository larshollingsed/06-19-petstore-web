get "/add_new_user" do
  erb :"/user/add_user_form"
end

get "/add_user_confirm" do
  @new_user = User.add({"email" => params["new_user"]["email"], "password" => params["new_user"]["password"], "auth_level" => params["new_user"]["auth_level"], "location_owned" => params["new_user"]["location_owned"]})
  erb :"/menu"
end