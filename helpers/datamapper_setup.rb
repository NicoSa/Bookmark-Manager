env = ENV["RACK_ENV"] || "development"

require 'data_mapper'
require 'dm-timestamps'
require './lib/link'
require './lib/tag'
require './lib/user'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

DataMapper.finalize

DataMapper.auto_upgrade!
