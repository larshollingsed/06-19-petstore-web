# Takes the user to the new location form
get "/new_location_form" do
  erb :"new_location_form"
end

# Adds the location to the database and sends them back to the menu with a variable to notify them that addition was successful.  
get "/new_location_added" do
  @location = Location.new("name" => params["name"], "address" => params["address"], "retail" => params["retail"])
  @location.add_to_database
  erb :"menu"
end

# Takes the user to the delete location form
get "/delete_location_form" do
  erb :"delete_location_form"
end

# Returns user to the menu with a confirmation message if the location was deleted successfull.
# If not succesful takes them to the location_not_empty page.
get "/location_deleted" do
  @del = Location.find(params["id"])
  if @del.delete_if_empty
    erb :"menu"
  else
    erb :"location_not_empty"
  end
end

# Takes the user to the modify location form
get "/modify_location_form" do
  erb :"modify_location_form"
end

# Takes the user to a location modification form for a specific location
get "/modify_location_form_2" do
  erb :"modify_location_form_2"
end

# Modifies a location and returns user to the menu with a confirmation message
get "/location_modified" do
  x = {"id" => params["id"].to_i, "name" => params["name"], "address" => params["address"], "retail" => params["retail"]}
  @modify = Location.new(x)
  @modify.save
  erb :"menu"
end

# Takes user to the show locations page
get "/show_locations" do
  erb :"show_locations"
end