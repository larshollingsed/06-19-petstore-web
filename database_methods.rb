require "active_support"
require "active_support/inflector"

module DatabaseClassMethods
  
  # Gets all rows from a table
  # Returns an Array of Objects
  def all
    table_name = self.to_s.pluralize.downcase
    array_of_hashes = DB.execute("SELECT * FROM #{table_name};")
    array_of_objects = []
    array_of_hashes.each do |one_hash|
      object = self.new(one_hash)
      array_of_objects << object
    end
    array_of_objects
  end
  
  # Gets a specific row from a table and populates an Object
  # Returns an Object
  def find(id)
    table_name = self.to_s.pluralize.downcase
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
  
  def add(args={})
    column_names = args.keys
    values = args.values
    column_names_for_sql = column_names.join(", ")
    individual_values_for_sql = []
    values.each do |value|
      if value.is_a?(String)
        individual_values_for_sql << "'#{value}'"
      else  
        individual_values_for_sql << value
      end  
    end
    values_for_sql = individual_values_for_sql.join(", ")
    table_name = self.to_s.pluralize.underscore
  
    DB.execute("INSERT INTO #{table_name} (#{column_names_for_sql}) VALUES (#{values_for_sql});")

    id = DB.last_insert_row_id
    args["id"] = id

    self.new(args)
  end
end