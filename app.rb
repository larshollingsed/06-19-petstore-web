require "sqlite3"
require "sinatra"
require "pry"
require_relative "categories.rb"
require_relative "locations.rb"
require_relative "products.rb"
require_relative "module.rb"
require_relative "orm.rb"
require "sinatra/reloader"

DB = SQLite3::Database.new("petstore.db")
DB.execute("CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY, type TEXT);")
DB.execute("CREATE TABLE IF NOT EXISTS locations (id INTEGER PRIMARY KEY, name TEXT, address TEXT, retail INTEGER);")
DB.execute("CREATE TABLE IF NOT EXISTS products (id INTEGER PRIMARY KEY, category_id INTEGER, location_id INTEGER, name TEXT, cost FLOAT, quantity INTEGER);")
DB.results_as_hash = true
#-------------------------------------------------------------------------------

# Main menu from which to select various options
get "/menu" do
  erb :"menu"
end

# Goes to the form for adding a brand new product
get "/new_product_form" do
  erb :"new_product_form"
end

# Makes sure an animal isn't being added to a non-retail location.
# If true then reroutes to the menu (carrying the new Product).
# If false then returns to the new product form with a message informing the user of the error and populating the form with the info provided previously.
get "/add_new_product" do
  @new_product = Product.new({"location_id" => params["location_id"].to_i, "category_id" => params["category_id"].to_i, "name" => params["name"], "cost" => params["cost"].to_i, "quantity" => params["quantity"].to_i})
  if @new_product.add_to_database 
    erb :"menu"
  else
    @animal_in_non_retail = true
    erb :"new_product_form"
  end
end

# Shows a list of all products
get "/show_products" do
  erb :"show_products"
end

# Goes to the delete product form
get "/delete_product_form/:location" do
  erb :"delete_product_form"
end

# Deletes product from database
# Also sends a variable on the way to the menu to notify the user that deletion was successful.
get "/delete_product" do
  @del = []
  params["id"].each do |x|
    @del << Product.find(x)
    Product.find(x).delete
  end
  erb :"menu"
end

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

# Takes user to the inventory values page
get "/inventory_values" do
  erb :"inventory_values"
end
  
# Takes user to the show locations page
get "/show_locations" do
  erb :"show_locations"
end

# Takes user to the modify product form
get "/modify_product_form/:location" do
  erb :"modify_product_form"
end

# After selecting which product to modify, this takes them to a form for that specific product.
get "/modify_product_form_2" do
  erb :"modify_product_form_2"
end

# If modification of product is successful then returns them to the menu with a confimation message.
# If non-successful returns them to the modify product form with a message about animals in non-retail
get "/product_modified" do
  x = {"id" => params["id"].to_i, "location_id" => params["location_id"].to_i, "category_id" => params["category_id"].to_i, "name" => params["name"], "cost" => params["cost"].to_f, "quantity" => params["quantity"].to_i}
  @modify = Product.new(x)
  if @modify.animal_in_non_retail? == false
    @modify.save
    erb :"menu"
  else
    @animal_in_non_retail = true
    erb :modify_product_form_2
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

# Takes the user to the product display by location page
get "/product_display_by_location" do
  erb :"product_display_by_location"
end

# Takes the user to the product display by category page
get "/product_display_by_category" do
  erb :"product_display_by_category"
end