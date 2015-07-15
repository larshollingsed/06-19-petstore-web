require "active_support"
require "active_support/inflector"

module DatabaseClassMethods
  
  # Creates a generalized table name for database modules
  # Returns a String of the table name
  def table_name
    self.to_s.pluralize.downcase
  end
  
  # Gets all rows from a table
  # Returns an Array of Objects
  def all
    array_of_hashes = DB.execute("SELECT * FROM #{table_name};")
    array_of_objects = []
    array_of_hashes.each do |one_hash|
      array_of_objects << self.new(one_hash)
    end
    array_of_objects
  end
  
  # Gets a specific row from a table and populates an Object
  # Returns an Object
  def find(id)
    one_hash = DB.execute("SELECT * FROM #{table_name} WHERE id = #{id};")[0]
    object = self.new(one_hash)
  end
  
  def hash_to_object(array_of_hashes)
    array_of_objects = []
    array_of_hashes.each do |one_hash|
      object = self.new(one_hash)
      array_of_objects << object
    end
    array_of_objects
  end
  
  def sql_column_names(args)
    column_names = args.keys
    column_names.join(", ")
  end
  
  def sql_values(args)
    values = args.values
    individual_values_for_sql = []
    values.each do |value|
      if value.is_a?(String)
        individual_values_for_sql << "'#{value}'"
      else  
        individual_values_for_sql << value
      end  
    end
    individual_values_for_sql.join(", ")
  end

  def create_with_new_id(args)
    id = DB.last_insert_row_id
    args["id"] = id

    self.new(args)
  end
  
  def add(args={})
    column_names_for_sql = sql_column_names(args)
    values_for_sql = sql_values(args)

    DB.execute("INSERT INTO #{table_name} (#{column_names_for_sql}) VALUES (#{values_for_sql});")

    create_with_new_id(args)
  end
  
end