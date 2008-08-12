# custom exception
# wird geworfen, wenn unbekannter userlevel abgefragt wird etc. (siehe User model)
class InvalidUserLevelError < Exception
  
  def initialize(message)
    super(message)
  end
  
end