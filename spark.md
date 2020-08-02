RDD persistence:

 - MEMORY\_ONLY - unserialized
 - MEMORY\_ONLY\_SER - serialized
 - MEMORY\_AND\_DISK
 - MEMORY\_AND\_DISK\_SER
 - DISK\_ONLY
 - add \_2 to store on 2 machines

unpersist to evict manually. TODO is it necessary?

The textFile method also takes an optional second argument for controlling 
the number of partitions of the file. By default, Spark creates one 
partition for each block of the file (blocks being 64MB by default in HDFS), 
but you can also ask for a higher number of partitions by passing a larger 
value. Note that you cannot have fewer partitions than blocks.

SparkContext.wholeTextFiles lets you read a directory containing multiple 
small text files, and returns each of them as (filename, content) pairs. 
This is in contrast with textFile, which would return one record per line 
in each file.

``coalesce`` vs ``repartition``, coalesce always reduces partitions so a bit 
less data movement, always use coalesce when parallelism gets <.

 - reducers: groupBy\*




## Spark streaming

### Basic stuff

```Scala
parsedData
  .withWatermark("timestamp", "10 minutes") // how late can a new event be
  // query semantics, how to group data
  .groupBy(window("timestamp", "5 minutes"))
  .count()
  .writeStream
  .trigger("10 seconds") // how often to emit updates
  .start()
```

Watermark is saved as part of the checkpoint location.

Only time-based windows are supported.


### Deduplication

Uses statestore, can deduplicate by fields or by entire object.

When using `withWatermark` too, watermark will drop some, dedupe will drop 
some from the result.


### Streaming joins

Spark 2.0+ - joins between streams and static datasets

Spark 2.3+ - stream stream joins


Left and Right joins are allowed only with time constraints and watermarks. 
E.g.:

```Scala
impressionsWithWatermark.join(
  clicksWithWatermark,
  expr("""
    clickAdId = impressionAdId AND
    clickTime >= impressionTime AND
    clickTime <= impressionTime + inteval 1 hour
    """ 
  ),
  joinType = "leftOuter"
)
```

Without time limits and watermarks it wouldn't really know when to emit left 
side + nulls or right side + nulls




#### Arbitrary Stateful Operations

No state cleanup or dropping of old data!!!

Watermark works, but you need to drop existing old data explicitly.

When a group does not get any event for a while, `mapGroupsWithState`
it is called with an empty iterator. (This functionality is mentioned as 
"timeouts") 


```
userActions
  .withWatermarks("timestamp")
  .groupByKey(_.userId)
  .mapGroupWithState(EventTimeTimeout)(updateState)

def updateState(...): UserStatus = {
  state.setTimeoutTimestamp(maxActionTimeStamp, "1 hour")
}
```

to remove you need to check for `state.hasTimedOut` and `state.remove()`
on event or on timeout event (which is also an event sooooo)


Event-time Timeout - When?


Watermark is calculated with max event time across all groups.


For a specific group, if there is no event till watermark exceeds the 
timeout timestamp:

then function is called with empty iterator, hasTimedOut == true

else func is called with new data, need to set new timeout manually



ProcessingTimeTimeout - wallclock, much simpler. Independent of watermarks.

Query downtimes will cause lots of timeouts after recovery!!!




##### Function output mode

`flatMapGroupsWithState(outputMode, timeoutConf)`

Gives spark insights into the output of the opaque function.

UpdateMode - events are KV pairs updating the value of a key in the result table

AppendMode - events are independent rows appended to the result table

This allows the planner to correctly compose `flatMapGroupsWithState` with
other operations


#### Optimizing Query State

##### Set number of shuffle partitions to 1-3 times number of cores

number is too low -> not all cores are used, lower throughput.

too high -> writing to hdfs will get slower.


##### Total size of state per worker

Larger state leads to higher overheads of snapshotting, JVM GC pauses, etc.


##### Monitoring the state of Query State


1. get current state metrics: `val progress = query.lastProgress; print(progress.json)`

2. get async state metris `new StreamingQueryListener`


##### Managing large state

State is kept on JVM heap. !!! Serialized on HDFS for redundancy/fault-tolerance.

millions of state keys per worker may cause GC issues and
limits depend on the size and complexity of the state data structures.

This is mitigated by using databricks runtime which uses
RocksDB.


#### Debugging


Explore dag.



