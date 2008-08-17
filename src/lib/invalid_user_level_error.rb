# custom exception
# gets raised if theres a unknown/invalid userlevel being requested (=> user model)
class InvalidUserLevelError < Exception
  
  def initialize(message)
    super(message)
  end
  
end