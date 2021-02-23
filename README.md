### CALL CLIENT INSTALLATION INSTRUCTIONS

* `git clone git@github.com:weyus/call_client.git`

* Make sure rvm is installed with Ruby 2.7.2 (`rvm list`)

* `cd call_client` (should create call_client gemset for you automatically)

* `bundle`

## RUNNING CALL CLIENT

* irb -r ./call_client.rb

* :001 > CallClient.new.call(2,3,'sum')
  Call SumServer...
   => 5
   
* :002 > CallClient.new.call(2,3,'difference')
  Call DifferenceServer...
   => -1

* :003 > CallClient.new.call('tests', 'rule', 'concatenate_upcase')
  Call ConcatenateUpcaseServer...
   => "TESTSRULE"

## RUNNING TESTS 

* rake

## COMMENTARY

* For the Arithmetic servers, I used a strategy pattern by defining different operators at
create time for specific servers. The fact that I could collapse all of that behavior into one method call on the ancestor ("calculate")
was a convenience that just happened.

* Originally wrote with networked servers in mind, then put in the class implementations. I left the network stuff to illustrate that kind of server use case.

* Externalized as much config as I could out of the code.

* Structured the servers to be as abstract with respect to operands as possible after reading the whole exercise. Adding the 
ConcatenateUpcase server was pretty straightforward. The only trick was that String operators can modify the operands in place
and so had to account for that in the "calculate" method.

* Note that the StringServer descendants can provide any number of String operations to run. I added the ConcatenateUpcaseReverse server 
and tests to demonstrate this.

POTENTIAL NEXT STEPS:

* Maybe make the retry logic into a method that takes a block to clean up CallClient#call() a bit

* Create a server hierarchy for class, network, other? servers to remove ugly if statement from CallClient#call() and tests

* Pull server operations themselves into config? Maybe.

* Add logic to verify that Integer or String "respond_to?" the operators provided at instantiation time, although this may be a bit overkill. 


 