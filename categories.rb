require_relative "database_methods.rb"
require_relative "database_instance_methods.rb"
class Category
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :type
  def initialize(args={})
    @id = args["id"]
    @type = args["type"]
  end
  
  # Counts total prices for all items in a specific category
  # Returns Float of total value (cost * quantity) for all items in category
  def inventory_value
    x = DB.execute("SELECT * FROM products WHERE category_id = #{@id};")
    x = hash_to_object(x)
    Orm.calc_value(x)
  end
end
