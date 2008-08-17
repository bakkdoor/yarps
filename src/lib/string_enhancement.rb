  
# small enhancements to string class
module StringEnhancement
  
  include GLoc
  
  # adjusts string's ending with an 's or just a '
  # depending on if theres no 's' at the end or not
  # usage for example: login_name.his_her Profile page 
  # chris ==> chris' Profilseite 
  # mark  ==> mark's Profilseite
  def his_her
    if self.end_with? "s"
      self + "'"
    else
      self + "'s"
    end
  end
  
  # returns a language-code based on a given language-name
  # examples: 
  # "deutsch" -> "de"
  # "english" -> "en"
  # "francais" -> "fr"
  # etc...
  def lang_code
    case self
      when "de": :de
      when "en" : :en
      when (l :german): :de
      when (l :english): :en
    end
  end
  
  # reverse of lang_code
  # returns the language-name (in that language) based on a given language-code
  def lang_word
    case self
      when "de" : (l :german)
      when "en" : (l :english)
    end
  end
  
end
