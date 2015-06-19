require_relative "database_methods.rb"
require_relative "database_instance_methods.rb"

class Product
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :category_id, :location_id, :name, :cost, :quantity
  def initialize(args={})
    @id = args["id"]
    @category_id = args["category_id"]
    @location_id = args["location_id"]
    @name = args["name"]
    @cost = args["cost"]
    @quantity = args["quantity"]
  end
  
  # Checks to see if category = animal AND location = non-retail
  # Returns True/False
  def animal_in_non_retail?
    location = Location.find(@location_id)
    @category_id == 1 && location.is_retail? == nil
  end
  
  # Adds a product to the products table
  # Returns false or Integer of the new ID created
  def add_to_database
    if self.animal_in_non_retail?
      false
    else
      DB.execute("INSERT INTO products (location_id, category_id, name, cost, quantity) VALUES (#{@location_id}, #{@category_id}, '#{@name}', #{@cost}, #{@quantity});")
      @id = DB.last_insert_row_id
    end
  end
  
  # Saves an instance of a Product back to the database
  # Returns Self
  def save
     DB.execute("UPDATE products SET location_id = #{@location_id}, category_id = #{@category_id}, name = '#{@name}', cost = #{@cost}, quantity = #{@quantity} WHERE id = #{@id};")
     self
  end
   
  # Compiles a list of all products in a given category
  # category - Integer 
  # Returns an Array containing Product objects
  def self.all_in_category(category)
    x = DB.execute("SELECT * FROM products WHERE category_id = #{category};")
    hash_to_object(x)
  end
  
  # Compiles a list of all products at a given location
  # location - Integer
  # Returns an Array containing Product objects
  def self.all_at_location(location)
    x = DB.execute("SELECT * FROM products WHERE location_id = #{location};")
    hash_to_object(x)
  end
  
  # Compiles a total inventory value for everything in products table
  # Returns a Float 
  def self.inventory_value
    x = Product.all
    Orm.calc_value(x)
  end
  
  # Deletes the entire row from the product table
  # Returns Self
  def delete
    DB.execute("DELETE FROM products WHERE id = #{@id};")
    return self
  end
  
  # Determines if a product is an animal
  # Returns True/False
  def is_animal?
    @category_id == 1
  end  
  
  # Determines if a Product to be moved is an animal and if they new location is retail
  # loc - Integer of location_id for the product to be moved to
  # Returns True/False
  def move_animal_to_non_retail?(loc)
    location = Location.find(loc)
    if @category_id == 1 && location.is_retail? == nil
      true
    else
      false
    end
  end
  
  # Moves a Product's location
  # loc - Integer of location_id for the product to be moved to
  # Returns True/False
  def move(loc)
    if self.move_animal_to_non_retail?(loc)
      false
    else
      @location_id = loc
      true
    end
  end
end