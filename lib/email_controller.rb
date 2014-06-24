require 'rest_client'

module Email

  def send_recovery_email(token, email)
    RestClient.post "https://api:key-7ap14r7nxhar8f19n1xrbp6c3lz9-k99"\
      "@api.mailgun.net/v2/app25052767.mailgun.org/messages",
      :from => "nico@nicosaueressig.de",
      :to => "datenhandel247@googlemail.com",
      :subject => "Reset password for Bookmark Manager",
      :text => "Is this your email: #{email} ? To reset your password copy and paste this link to your browser:\n\n
        http://localhost:9393/reset_password/#{token}"
      #debug message
      puts "Send without Errors"
  end

end
