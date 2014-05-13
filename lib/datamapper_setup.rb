env = ENV["RACK_ENV"] || "development"
database_url = "postgres://localhost/bookmark_manager_#{env}"
require 'data_mapper'
require 'dm-timestamps'
require_relative './link.rb'
require_relative './tag.rb'
require_relative './user.rb'

DataMapper.setup(:default, ENV["DATABASE_URL"] || database_url )

DataMapper.finalize

DataMapper.auto_upgrade!
