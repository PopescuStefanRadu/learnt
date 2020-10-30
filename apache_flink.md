
## Functions

Functions can be executed remotely, with message and state sent in the request
This way they behave like stateless processes and support rapid scaling, 
rolling upgrades, etc.


Function invocations use a simple HTTP/gRPC-based protocol, functions can be 
implemented in various languages



 - dynamic messaging - not acyclic (kafka has it, spark not)
 - exactly once:
  - persisted states - fault tolerant
  - fault tolerance - in case of failure, the netire state is rolled back
  - event egress - arbitrary computation can be done from functions, but by 
    using event egress you can integrate with Flink
 - 
