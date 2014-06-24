require 'spec_helper'

feature "User adds a new link" do

  include AddLink

  before(:each) do
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "when browsing the homepage" do
    expect(Link.count).to eq 0
    visit '/'
    sign_in('test@test.com', 'test')
    add_link("http://www.makersacademy.com/", "Makers Academy")
    expect(Link.count).to eq 1
    link = Link.first
    expect(link.url).to eq("http://www.makersacademy.com/")
    expect(link.title).to eq("Makers Academy")
  end

  # scenario "with a few tags" do
  #   visit "/"
  #   sign_in('test@test.com', 'test')
  #   add_link("http://www.makersacademy.com",
  #            "Makers Academy")
  #   link = Link.first
  #   expect(link.tags.map(&:text)).to include("education")
  #   expect(link.tags.map(&:text)).to include("ruby")
  # end
end
