module AddLink

  def add_link(url, title)
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      click_button 'Add link'
  end

end