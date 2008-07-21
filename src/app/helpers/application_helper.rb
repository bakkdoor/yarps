# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
  include TagsHelper
	
	# small adjustment, so newlines work (-> "<br/>")
	def textilize(text)
		RedCloth.new(text).to_html
	end
	
	def yarps_version
	    0.1
	end
	
	def alphabet_letters
        ("a".."z").to_a
  end
  
  def tag_cloud_css_classes
    %w(tag_cloud_1 tag_cloud_2 tag_cloud_3 tag_cloud_4) 
  end
	
end

# mixing in TimeEnhancement-module
class Time
	include TimeEnhancement # see /lib
end

# mixing in ArrayEnhancement-module
class Array
	include ArrayEnhancement # see /lib
end

# mixing in StringEnhancement-module
class String
  include StringEnhancement # see /lib
end
