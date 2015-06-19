module Orm  
  # Calculates the total value of inventory
  # x - Array of Product objects
  # Returns a Float
  def self.calc_value(x)
    value = 0
    x.each do |y|
      
      value += y.cost * y.quantity
    end
    value
  end
      
end