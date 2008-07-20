class Menu
    
    # für l() methode
    include GLoc
    
    # main menu list...
	# wird irgendwann evtl aus datenbank kommen (dynamisch anpassbar...)
	def self.main_menu_list
	    menu_items = [ 
	            ["home",(l :home)], 
	            ["account", (l :account)],
	            ["users", (l :users)],
	            ["projects", (l :projects)],
	            ["about", (l :about)],
	            ["contact", (l :contact)]
            ]
            
        # lauf durch alle einträge (jeweils arrays) im array und pack in ein hash
        hashes = Array.new    
        menu_items.each do |item|
            hashes << { :controller => item[0], :link_text => item[1] }
        end
	       
        hashes # hash-array wird zurückgegeben
    end
    
    def self.private_menu_list
	    menu_items = [ 
	            ["news",(l :news)], 
	            ["tasks", (l :my_tasks)],
	            ["projects", (l :my_projects)],
	            ["account/settings", (l :my_settings)]
            ]
            
        # lauf durch alle einträge (jeweils arrays) im array und pack in ein hash
        hashes = Array.new    
        menu_items.each do |item|
            hashes << { :controller => item[0], :link_text => item[1] }
        end
	       
        hashes # hash-array wird zurückgegeben    
    end
end