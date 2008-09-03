# small enhancements to array class
module ArrayEnhancement
  	
	# returns a new array with the first amount elements left out.
	def skip(amount)
		self - self.first(amount)
	end
		
	def random
		self[rand(self.size)]
	end
	
end
