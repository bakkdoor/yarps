class Menu
  # für l() methode
  include GLoc  

  # main menu list...
	# maybe sometime get this from a database (dynamically adjustable...)
	def self.main_menu_list
	  menu_items = [ 
            ["home",(l :home)], 
            ["account", (l :account)],
            ["users", (l :users)],
            ["projects", (l :projects)],
            ["tags", (l :tags)],
            ["about", (l :about)],
            ["contact", (l :contact)]
          ]
          
    # loop through all entries (each an array) and put in a hash
    # and return hash-array
    put_menu_items_in_hash(menu_items)
  end
  
  def self.private_menu_list(current_user)
    menu_items = [ 
            ["news",(l :news)], 
            ["tasks", (l :my_tasks)],
            ["projects", (l :my_projects)],
            ["messages", "#{l :messages} (#{current_user.amount_new_messages})"],
            ["account/settings", (l :my_settings)]
          ]
          
    # loop through all entries (each an array) and put in a hash
    # and return hash-array    
    put_menu_items_in_hash(menu_items)
  end
  
  def self.put_menu_items_in_hash(menu_items)
    hashes = Array.new    
    menu_items.each do |item|
        hashes << { :controller => item[0], :link_text => item[1] }
    end
    
    hashes
  end
  
end