require "active_support"
require "active_support/inflector"

module DatabaseInstanceMethods

  # Deletes a row in a table
  def delete
    table_name = self.class.to_s.pluralize.downcase
    DB.execute("DELETE FROM #{table_name} WHERE id = #{@id};")
  end
  
  def hash_to_object(x)  
    y = []
    x.each do |z|
      product = Product.new(z)
      y << product
    end
    y
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
    options["id"] = id

    self.new(args)
  end
end
