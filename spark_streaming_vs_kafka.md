Spark saves to hdfs, Kafka to topics and local store. If everything
fits into memory Spark will be in the lead, if it doesn't the local
store might offset the batch-processing throughput advantage.


Spark with support from databricks is similar in that it uses RocksDB and 
local store(I think) so this version could be on par with Kafka.


Spark uses micro-batches and the api has access to a batch.
This means higher throughput and higher latency compared to kafka.
Kafka's api does not allow this. Realtime Spark is in beta mode.


Spark does not isolate a task. You might be processing two tasks
simultaneously on the same partition in different processing phases
(todo verify). Kafka guarantees that a tasks starts and finishes completely
isolated, no other task may be running on same thread/pipe/process(w.e.).
This means that I/O inside functions is much more reliable if you have
stateful operations.


In stateful operations spark has access to state only by current key,
kafka has random access to the state as well as range. State management
is much simpler and allows more variety in kafka streams.

State store is in memory!!! So you need a lot of memory per partition, 
and you will have GC issues for lots of keys and big state.

