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

get "/menu" do
  erb :"menu"
end
get "/new_product_form" do
  erb :"new_product_form"
end

get "/add_new_product" do
  product = Product.new({"location_id" => params["location_id"].to_i, "category_id" => params["category_id"].to_i, "name" => params["name"], "cost" => params["cost"].to_i, "quantity" => params["quantity"].to_i})
  if product.add_to_database 
    erb :"added_new_product"
  else
    "Failed to add product"
  end
end
#
#   # Add new product
#   if answer == 1
#     new_product = {}
#     Helper.list_locations
#     puts "Which location \# would you like to add the product to?"
#     new_product["location_id"] = gets.chomp.to_i
#     Helper.list_categories
#     puts "Which category \# is this item?"
#     new_product["category_id"] = gets.chomp.to_i
#     puts "Name of the new item:"
#     new_product["name"] = gets.chomp.to_s
#     puts "Cost per item:"
#     new_product["cost"] = gets.chomp.to_f
#     puts "Quantity:"
#     new_product["quantity"] = gets.chomp.to_i
#     product = Product.new(new_product)
#     if product.add_to_database
#       puts "Product added."
#     else
#       puts "Product NOT added."
#     end
#
#     # Delete product
#   elsif answer == 2
#     Helper.list_products
#     puts "Which product \# would you like to delete?"
#     del_product = {}
#     del_product["id"] = gets.chomp.to_i
#     del = Product.new(del_product)
#     del.delete
#     puts "Product deleted."
#
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
#   # List all products
#   elsif answer == 4
#     Helper.list_products
#
#     # Add location
#   elsif answer == 5
#     puts "Name of new location:"
#     loc = {}
#     loc["name"] = gets.chomp.to_s
#     puts "Address of new location:"
#     loc["address"] = gets.chomp.to_s
#     puts "Retail? (yes/no)"
#     loc["retail"] = gets.chomp
#     location = Location.new(loc)
#     if location.add_to_database
#       puts "Location added."
#     else
#       puts "Location not added."
#     end
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