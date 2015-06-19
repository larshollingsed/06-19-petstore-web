require_relative "database_methods.rb"
require_relative "database_instance_methods.rb"

class Location
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  attr_accessor :id, :name, :address, :retail
  def initialize(args={})
    @id = args["id"]
    @name = args["name"]
    @address = args["address"]
    if args["retail"] == "yes" || args["retail"] == 1
      @retail = true
    end
  end
  
  def add_to_database
    retail_to_int
     DB.execute("INSERT INTO locations (name, address, retail) VALUES ('#{@name}', '#{@address}', #{@retail});")
  end
  
  # Adds a new location to the locations table
  # name - String containing the name of the location
  # address - String containing the address of the location
  # retail - INTEGER 0 = false, 1 = true
  # Returns TRUE  
  def self.add(name, address, retail)
    DB.execute("INSERT INTO locations (name, address, retail) VALUES ('#{name}', '#{address}', #{retail});")
    TRUE
  end
    
  def retail_to_int
    if @retail == true || @retail == "yes" || @retail == 1
      @retail = 1
    else
      @retail = 0
    end
  end
  
  def save
    retail_to_int
     DB.execute("UPDATE locations SET name = '#{@name}', address = '#{@address}', retail = #{@retail} WHERE id = #{@id};")
   end
   
  # Deletes the entire row from the locations table
  # Returns TRUE
  def delete_if_empty
    if is_empty?
      delete
    else
      false
    end
  end
  
  # Determines if a location is a retail store
  # Returns True/False
  def is_retail?
    @retail
  end  
  
  # Determines if a location is empty of products
  # Returns True/False
  def is_empty?
    x = DB.execute("SELECT * FROM products WHERE location_id = #{@id};")
    x.empty?
  end  
  
  # Counts total prices for all items at a specific location
  # Returns Float of total value (cost * quantity) for all items at location
  def inventory_value
    x = DB.execute("SELECT * FROM products WHERE location_id = #{@id};")
    x = hash_to_object(x)
    Orm.calc_value(x)
  end
end