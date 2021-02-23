class InvalidServerTypeException < ::StandardError
  def initialize(server_type)
    @server_type = server_type
  end

  def message
    "#{@server_type} is not a valid server type."
  end
end