# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	# small adjustment, so newlines work (-> "<br/>")
	def textilize(text)
		RedCloth.new(text).to_html
	end
	
	def yarps_version
	    0.3
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
