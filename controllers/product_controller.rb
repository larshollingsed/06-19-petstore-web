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

# Takes the user to the product display by location page
get "/product_display_by_location" do
  erb :"product_display_by_location"
end

# Takes the user to the product display by category page
get "/product_display_by_category" do
  erb :"product_display_by_category"
end

get "/modify_or_delete_products" do
  if params["delete_id"]
    @delete = params["delete_id"]
    erb :"delete_product_form"
  elsif params["modify_id"]
    @modify_id = params["modify_id"]
    erb :"modify_product_form_2"
  end
end