require 'bcrypt'
require_relative "../database_methods.rb"
require_relative "../database_instance_methods.rb"

class User
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :email, :location_owned, :auth_level
  attr_reader :password
  
  def initialize(args={})
    @id = args["id"]
    @email = args["email"]
    @auth_level = args["auth_level"]
    @location_owned = args["location_owned"]
    @password = args["password"]
  end
  
  def self.get_user_for_login(email)
    user = DB.execute("SELECT * FROM users WHERE email = '#{email}';")[0]
    password = BCrypt::Password.new(user["password"])
    User.new({"id" => user["id"], "password" => password})
  end
  
  def correct_password?(attempted_password)
    self.password == attempted_password
  end
    
end