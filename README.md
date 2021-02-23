### CALL CLIENT INSTALLATION INSTRUCTIONS

* `git clone git@github.com:weyus/call_client.git`

* Make sure rvm is installed with Ruby 2.7.2 (`rvm list`)

* `cd call_client` (should create call_client gemset for you automatically)

* `bundle`

## RUNNING CALL CLIENT

* irb -r ./call_client.rb

* :001 > CallClient.new.call(2,3,'sum')
   => 5
   
* :002 > CallClient.new.call(2,3,'difference')
   => -1

* :003 > CallClient.new.call('tests', 'rule', 'concatenate_upcase')
   => "TESTSRULE"

## RUNNING TESTS 

* rake

## COMMENTARY

* For the Arithmetic servers, I used a strategy pattern by defining different operators at
create time for specific servers. The fact that I could collapse all of that behavior into one method call on the ancestor ("calculate")
was a convenience that just happened.

* Originally wrote with networked servers in mind, then put in the class implementations.

* Externalized as much config as I could out of the code.

* Structured the servers to be as abstract with respect to operands as possible after reading the whole exercise. Adding the 
ConcatenateUpcase server was pretty straightforward. The only trick was that String operators can modify the operands in place
and so had to account for that in the "calculate" method.

POTENTIAL NEXT STEPS:

* Maybe make the retry logic into a method that takes a block to clean up CallClient#call() a bit

* Create a server hierarchy for class, network, other? servers to remove ugly if statement from CallClient#call() and tests 

 