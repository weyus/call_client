require './spec/spec_helper.rb'

describe CallClient do
  %w(sum difference).each do |server_type|
    context "happy path for #{server_type}" do
      it "successfully calls #{server_type} server" do
        server_instance = "#{server_type.capitalize}Server".constantize.new
        op1, op2 = rand(10), rand(10)

        call_client = CallClient.new
        sum_config = CallClient::SERVER_TYPES[server_type]

        expect(call_client).to receive(:find_server_type).with(server_type).and_return(sum_config)
        expect(call_client).to receive(:validate_operands).with(op1, op2, sum_config)

        if CallClient::MODE == 'network'
          response_double = double(Net::HTTPResponse)
          allow(response_double).to receive(:body).and_return(server_instance.calculate(op1, op2))
          expect(RestClient).to receive(:get).with("http://#{sum_config['host']}:#{sum_config['port']}/3/4").and_return(response_double)
        end

        expect(call_client.call(op1, op2, server_type)).to eq(server_instance.calculate(op1, op2))
      end
    end

    context "errors for #{server_type} server" do
      before(:all) do
        @call_client = CallClient.new
      end

      it "raises InvalidServerTypeException when a bad server type is given to it" do
        op1, op2, bad_server_type = 'x', 'y', 'garbage'

        expect {@call_client.call(op1, op2, bad_server_type)}.to raise_error(InvalidServerTypeException,
                                                                             "#{bad_server_type} is not a valid server type.")
      end

      it "raises InvalidInputException when bad input is given to it" do
        op1, op2 = 'x', 'y'

        operand_type = CallClient::SERVER_TYPES[server_type]['operand_type']

        expect {@call_client.call(op1, op2, server_type)}.to raise_error(InvalidInputException,
                                                                         "One or both of the operands #{op1} and #{op2} are not #{operand_type}s")
      end

      context "call failures" do
        before(:each) do
          @server_class = "#{server_type.capitalize}Server".constantize
          @server_instance = @server_class.new
          @op1, @op2 = rand(10), rand(10)
        end

        it "retries 3 times before failing" do
          if CallClient::MODE == 'class'
            allow(@server_class).to receive(:new).and_return(@server_instance)
            allow(@server_instance).to receive(:calculate).and_raise(StandardError.new("error"))
          else
            allow(RestClient).to receive(:get).and_raise(StandardError.new("error"))
          end
          expect(@call_client).to receive(:call_server).with(@op1, @op2, CallClient::SERVER_TYPES[server_type]).exactly(CallClient::RETRIES).times

          @call_client.call(@op1, @op2, server_type)
        end

        it "raises CallClientException after failing" do
          if CallClient::MODE == 'class'
            allow(@server_class).to receive(:new).and_return(@server_instance)
            allow(@server_instance).to receive(:calculate).and_raise(StandardError.new("error"))
          else
            allow(RestClient).to receive(:get).and_raise(StandardError.new("error"))
          end

          expect {@call_client.call(@op1, @op2, server_type)}.to raise_error(CallClientException,
                                                                           "Something went wrong with the call to the remote server: type: StandardError, message: error")
        end
      end
    end
  end
end