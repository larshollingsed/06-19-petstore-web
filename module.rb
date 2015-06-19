module Helper
  # Puts a "table" of all products
  def self.list_products
    puts "ID - Loc - Category - Name - Cost - Quantity"
    Product.all.each do |x|
      puts "#{x.id} - #{x.location_id} - #{x.category_id} - #{x.name} - #{x.cost} - #{x.quantity}"
    end
  end
  
  def self.list_of_products(x)
    x.each do |y|
      puts "#{y.id} - #{y.location_id} - #{y.category_id} - #{y.name} - #{y.cost} - #{y.quantity}"
    end
  end

  
  # Puts a "table" of all locations
  def self.list_locations
    puts "ID  -  Name  -  Address  -  Retail?"
    Location.all.each do |x|
      puts "#{x.id} - #{x.name} - #{x.address} - #{x.retail}"
    end
  end
  
  # Puts a "table" of all categories
  def self.list_categories
    puts "ID  -  Category"
    Category.all.each do |x|
      puts "#{x.id} - #{x.type}"
    end
  end
end