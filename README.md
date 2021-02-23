### CALL CLIENT INSTALLATION INSTRUCTIONS

* git clone git@github.com:weyus/call_client.git

* Make sure rvm is installed with Ruby 2.7.2

* cd call_client (should create gemset for you)

* bundle

## RUNNING CALL CLIENT

* irb -r ./call_client.rb

* :001 > CallClient.new.call(2,3,'sum')
   => 5
   
* :002 > CallClient.new.call(2,3,'difference')
   => -1

## RUNNING TESTS 

* rake

## COMMENTARY

* For the Arithmetic servers, I used a strategy pattern by defining different operators at
create time for specific servers. The fact that I could collapse all of that behavior into one method call on the ancestor ("calculate")
was a convenience that just happened.

* Originally wrote with networked servers in mind, then put in the class implementations.

* Externalized as much config as I could out of the code.

 