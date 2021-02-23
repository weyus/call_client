require './dependencies.rb'

class CallClient
  CONFIG = YAML::load(File.open('config.yml'))
  MODE = CONFIG['mode']
  RETRIES = CONFIG['retries']
  SERVER_TYPES = CONFIG['servers']

  def call(operand1, operand2, server_type)
    server_info = find_server_type(server_type)
    validate_operands(operand1, operand2, server_info)

    exception = nil

    RETRIES.times do
      begin
        result = call_server(operand1, operand2, server_info)
        return result if result
      rescue StandardError => e
        exception = e
        next
      end
    end

    raise CallClientException.new(exception.class, exception.message) if exception
  end

  private

  def find_server_type(server_type)
    unless SERVER_TYPES.keys.include?(server_type)
      raise InvalidServerTypeException.new(server_type)
    end

    SERVER_TYPES[server_type]
  end

  def validate_operands(op1, op2, server_info)
    op_type = server_info['operand_type']
    klass = op_type.constantize

    unless op1.is_a?(klass) && op2.is_a?(klass)
      raise InvalidInputException.new(op1, op2, op_type)
    end
  end

  def call_server(op1, op2, server_info)
    begin
      if MODE == 'class'
        server_info['name'].constantize.new.calculate(op1, op2)
      else
        response = RestClient.get("http://#{server_info['host']}:#{server_info['port']}/#{op1}/#{op2}")
        response.body.to_i
      end
    rescue StandardError => e
      raise e
    end
  end
end