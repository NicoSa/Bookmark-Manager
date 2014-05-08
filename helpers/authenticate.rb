def self.authenticate(email, password)
	user = first(:email => email)
	if user && BCrypt::Password.new(user.password_digest) == password
		user
	else
		nil
	end
end