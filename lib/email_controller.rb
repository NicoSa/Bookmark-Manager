require 'mailgun'

module Email

def send_simple_message
  RestClient.post "https://api:pubkey-0cbmb-6iw9atxtgth58fry1kb-4z6yx4"\
  "@api.mailgun.net/v2/samples.mailgun.org/messages",
  :from => "@sandboxe716c2bbf707491595fd9291e8a90618.mailgun.org",
  :to => "datenhandel247@googlemail.com",
  :subject => "Hello",
  :text => "Testing some Mailgun awesomness!"
end

end