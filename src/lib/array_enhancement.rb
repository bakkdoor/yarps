# small enhancements to array class
module ArrayEnhancement
	
	# returns a new array with only the first amount elements.
	def take(amount)
		first_n = []
		
		if amount > self.size
			amount = self.size
		end
		
		amount.times do |n|
			first_n << self[n]
		end
		
		first_n
	end
	
	# returns a new array with the first amount elements left out.
	def skip(amount)
		self - self.take(amount)
	end
	
	# returns a new array with the last amount elements.
	def last_n(amount)
		self.skip(self.size - amount)
	end
	
	# same as last, only first (equal to take)
	def first_n(amount)
		self.take(amount)
	end
		
	def random
		self[rand(self.size)]
	end
	
end
