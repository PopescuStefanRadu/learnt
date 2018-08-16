#Java 
## Concurrency

 - While it may seem that field values set in a constructor are the first values written to those fields and therefore that there are no "older"
values to see as stale values, the Object constructor first writes the default values to all fields before subclass constructors run. It is therefore
possible to see the default value for a field as a stale value.
