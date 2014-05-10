#env = ENV["RACK_ENV"] || "development"

require 'data_mapper'
require 'dm-timestamps'
require_relative './link.rb'
require_relative './tag.rb'
require_relative './user.rb'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

DataMapper.finalize

DataMapper.auto_upgrade!
