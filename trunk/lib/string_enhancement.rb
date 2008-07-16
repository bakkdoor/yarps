# small enhancements to string class
module StringEnhancement
  
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
  
end
