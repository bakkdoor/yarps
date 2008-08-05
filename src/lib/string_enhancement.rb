  
# small enhancements to string class
module StringEnhancement
  
  include GLoc
  
  # fügt, je nachdem ob ein string mit 's' endet oder nicht, nur ' bzw 's an
  # gebrauch z.B.: login_name.his_her Profilseite
  # chris ==> chris' Profilseite 
  # mark  ==> mark's Profilseite
  def his_her
    if self.end_with? "s"
      self + "'"
    else
      self + "'s"
    end
  end
  
  # gibt in zum jeweiligen sprachnamen den sprachcode zurück
  # beispiele: 
  # "deutsch" -> "de"
  # "english" -> "en"
  # "francais" -> "fr"
  # usw...
  def lang_code
    case self
      when "de": :de
      when "en" : :en
      when (l :german): :de
      when (l :english): :en
    end
  end
  
  # ist die umkehrung von lang_code
  # gibt den sprachnamen (in der jeweiligen sprache) abhängig vom sprachcode zurück
  def lang_word
    case self
      when "de" : (l :german)
      when "en" : (l :english)
    end
  end
  
end
