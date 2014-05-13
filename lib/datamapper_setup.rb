env = ENV["RACK_ENV"] || "development"
database = ENV["DATABASE_URL"] || "postgres://localhost/bookmark_manager_#{env}"
require 'data_mapper'
require 'dm-timestamps'
require_relative './link.rb'
require_relative './tag.rb'
require_relative './user.rb'

DataMapper.setup(:default, database)

DataMapper.finalize

DataMapper.auto_upgrade!
