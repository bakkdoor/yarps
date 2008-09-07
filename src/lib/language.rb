# just a small helper-class for languages
class Language
  
  # gibt standard-sprache zurück.
  def self.default
    :en
  end
  
  def self.list
    [:en, :de]
  end
  
end