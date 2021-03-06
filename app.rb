require "rubygems"
require "bundler/setup"

require "sqlite3"
require "sinatra"
require "pry"
require "sinatra/reloader"

require_relative "module.rb"
require_relative "orm.rb"
require_relative "database_setup.rb"


require_relative "./controllers/location_controller.rb"
require_relative "./controllers/product_controller.rb"
require_relative "./controllers/user_controller.rb"

require_relative "./models/category.rb"
require_relative "./models/location.rb"
require_relative "./models/product.rb"
require_relative "./models/user.rb"

#-------------------------------------------------------------------------------

# Main menu from which to select various options
get "/menu" do
  erb :"menu"
end




# Takes user to the inventory values page
get "/inventory_values" do
  erb :"inventory_values"
end
  





