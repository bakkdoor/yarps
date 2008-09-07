# small enhancements to time class
module TimeEnhancement

  def german(format = :short)
    case format
      when :long
        self.strftime("%d.%m.%Y - %H:%M")
      else
        self.strftime("%d.%m.%Y")
    end
  end
  
  def english(format = :short)
    case format
      when :long
        self.strftime("%m.%d.%Y - %H:%M")
      else
        self.strftime("%m.%d.%Y")
    end
  end
	
	def format(options = {})
	  lang = options[:lang] || options[:language] || Language.default
	  format = options[:format]
	 
	  output = case lang
      when :de
        german(format)
      when :en
        english(format)
    end  
	end
	
end