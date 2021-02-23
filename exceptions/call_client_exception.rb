class CallClientException < ::StandardError
  def initialize(classname, message)
    @classname = classname
    @message = message
  end

  def message
    "Something went wrong with the call to the remote server: type: #{@classname}, message: #{@message}"
  end
end