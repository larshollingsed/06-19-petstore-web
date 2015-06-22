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
# If true then reroutes to the menu.
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

# Shows a list of all product
get "/show_products" do
  erb :"show_products"
end

# Goes to the delete product form
get "/delete_product_form" do
  erb :"delete_product_form"
end

# Deletes product from database
# Also sends a variable on the way to the menu to notify the user that deletion was successful.
get "/delete_product" do
  @del = Product.find(params["id"])
  @del.delete
  erb :"menu"
end

get "/new_location_form" do
  erb :"new_location_form"
end
  
get "/new_location_added" do
  @location = Location.new("name" => params["name"], "address" => params["address"], "retail" => params["retail"])
  if @location.add_to_database
    erb :"menu"
  else
    "Failed to add location"
  end
end

get "/delete_location_form" do
  erb :"delete_location_form"
end

get "/location_deleted" do
  @del = Location.find(params["id"])
  if @del.delete_if_empty
    erb :"menu"
  else
    erb :"location_not_empty"
  end
end

get "/inventory_values" do
  erb :"inventory_values"
end
  
get "/show_locations" do
  erb :"show_locations"
end

get "/modify_product_form" do
  erb :"modify_product_form"
end

get "/modify_product_form_2" do
  erb :"modify_product_form_2"
end

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

get "/modify_location_form" do
  erb :"modify_location_form"
end

get "/modify_location_form_2" do
  erb :"modify_location_form_2"
end

get "/location_modified" do
  x = {"id" => params["id"].to_i, "name" => params["name"], "address" => params["address"], "retail" => params["retail"]}
  @modify = Location.new(x)
  @modify.save
  erb :"menu"
end

get "/product_display_by_location" do
  erb :"product_display_by_location"
end

get "/product_display_by_category" do
  erb :"product_display_by_category"
end

#     # Modify product
#   elsif answer == 3
#     Helper.list_products
#     puts "Which product \# would you like to modify?"
#     product = Product.find(gets.chomp.to_i)
#     puts "Which field would you like to modify?", "location_id, category_id, name, cost, quantity"
#     old = gets.chomp.to_s
#     puts "What would you like to change it to?"
#     product.send("#{old}=", gets.chomp)
#     product.save
#
#     # Delete location
#   elsif answer == 6
#     Helper.list_locations
#     puts "Which location \# would you like to delete?"
#     del = Location.find(gets.chomp.to_i)
#     if del.delete_if_empty
#       puts "Location deleted"
#     else
#       puts "These are still at that location; must be moved first."
#       puts "ID - Category - Name - Cost - Quantity"
#       Helper.list_of_products(Product.all_at_location(choice))
#     end
#
#     # Modify location
#   elsif answer == 7
#     Helper.list_locations
#     loc = {}
#     puts "Which location \# would you like to modify?"
#     location = Location.find(gets.chomp.to_i)
#     puts "Which field would you like to modify?", "name, address, retail"
#     old = gets.chomp.to_s
#     puts "What would you like to change it to?"
#     location.send("#{old}=", gets.chomp)
#     location.save
#     puts "Location modified."
#
#     # See all locations
#   elsif answer == 8
#     Helper.list_locations
#
#     # Move product location
#   elsif answer == 9
#     Helper.list_products
#     puts "Which product \# would you like to move?"
#     move_product = Product.find(gets.chomp.to_i)
#     Helper.list_locations
#     puts "Which location \# would you like to move it to?"
#     # If the new location is not retail and the product to be moved in an animal
#     # Will not allow the move
#     if move_product.move(gets.chomp.to_i)
#       move_product.save
#       puts "Product moved."
#     else
#       puts "Failed to move product."
#     end
#
#     # Fetch all products in a category
#   elsif answer == 10
#     Helper.list_categories
#     puts "Which category \# would you like to see the products in?"
#     cat = gets.chomp.to_i
#     puts "ID - Loc - Name - Cost - Quantity"
#     Helper.list_of_products(Product.all_in_category(cat))
#
#     # Fetch all products from location
#   elsif answer == 11
#     Helper.list_locations
#     puts "Which location \# would you like to see the products at?"
#     location = gets.chomp.to_i
#     puts "ID - Category - Name - Cost - Quantity"
#     Helper.list_of_products(Product.all_at_location(location))
#
#     # Inventory values
#   elsif answer == 12
#     puts "Would you like to see the:", "1 - total inventory value", "2 - inventory value for a specific location", "3 - inventory value for a specific category"
#     answer = gets.chomp.to_i
#
#     # Total inventory value
#     if answer == 1
#       puts "The total value of all inventory is #{Product.inventory_value}"
#
#     # Inventory value at a specific location
#     elsif answer == 2
#       Helper.list_locations
#       puts "Location \#:"
#       puts "The total value of inventory at this location is #{Location.find(gets.chomp.to_i).inventory_value}"
#
#     # Inventory value for a specific category
#     elsif answer == 3
#       Helper.list_categories
#       puts "Category \#:"
#       puts "The total value of all items in this category is #{Category.find(gets.chomp.to_i).inventory_value}"
#     end
#   end
#
#   puts "What would you like to do?", "1 - Add a new product", "2 - Delete a product", "3 - Modify a product", "4 - Show all products", "5 - Add a location", "6 - Delete a location", "7 - Modify a location", "8 - See all locations", "9 - Move product location", "10 - Fetch all products in a category", "11 - Fetch all products from a location", "12 - Inventory values", "0 to quit"
#   answer = gets.chomp.to_i
# end