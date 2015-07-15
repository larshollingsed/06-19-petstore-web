require 'bcrypt'
require_relative "../database_methods.rb"
require_relative "../database_instance_methods.rb"

class User
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  def initialize(args={})
    @id = args["id"]
    @email = args["email"]
    @auth_level = args["auth_level"]
    @location_owned = args["location_owned"]
    @password = BCrypt::Password.create(args["password"])
  end
end