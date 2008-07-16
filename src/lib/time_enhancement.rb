# small enhancements to time class
module TimeEnhancement

def german(long_date = false)
		
		db_date = self.to_s(:db)
		date_en = db_date.split(" ")[0]
		time_en = db_date.split(" ")[1]
		
		date_split = date_en.split("-")
		time_split = time_en.split(":")
		
		hour = time_split[0]
		minute = time_split[1]
		
		day = date_split[2]
		month = date_split[1]
		year = date_split[0]
			
		if long_date == :long
			"#{day}.#{month}.#{year} - #{hour}:#{minute}"
		elsif long_date == :long_clock
		  "#{day}.#{month}.#{year} - #{hour}:#{minute} Uhr"
		else
			"#{day}.#{month}.#{year}"
		end
	end
	
end