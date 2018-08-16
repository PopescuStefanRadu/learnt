# Java 
## Concurrency

 - While it may seem that field values set in a constructor are the first values written to those fields and therefore that there are no "older"
values to see as stale values, the Object constructor first writes the default values to all fields before subclass constructors run. It is therefore
possible to see the default value for a field as a stale value.
 - Immutable objects can be used safely by any thread without additional synchronization, even when synchronization is
not used to publish them
 - Safe publication 
   - Initializing in ``static``
   - Storing in ``volatile`` or ``AtomicReference``
   - Storing in ``final`` field of a properly constructed object
   - Storing reference in a field that is properly guarded by a lock
