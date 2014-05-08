require 'bcrypt'
# require_relative '../helpers/bcrypt.rb'


class User

	# include BCrypt
	
	attr_reader :password
	attr_accessor :password_confirmation
	
	include DataMapper::Resource

	validates_uniqueness_of :email

	property :id, Serial
	property :email, String, :unique => true, :message => "This email is already taken"
	property :password_digest, Text

	validates_confirmation_of :password

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def self.authenticate(email, password)
	user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			user
		else
			nil
		end
	end
end