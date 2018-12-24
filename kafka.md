
max.poll.records + max.poll.interval.ms - max number of records received in a poll, if a consumer cannot finish consuming all the messages in that poll during max.poll.interval.ms then it will be considered failed -> rebalancing -> consumer was fine and now re-registers itself -> rebalancing again. This can lead to multiple message consumption duplicates

kafka - distributed commit log / distribute streaming platform

can have keys - in order to split data in partitions in a controlled manner

messages are sent/received usually in batches, which can be more easily compressed

can send message payloads of json/xml but many times avro is used since it comes with its own schema and is compact

A consistent data format is important in Kafka, as it allows writing and reading mes‐
sages to be decoupled. When these tasks are tightly coupled, applications that sub‐
scribe to messages must be updated to handle the new data format, in parallel with
the old format. Only then can the applications that publish the messages be updated
to utilize the new format. By using well-defined schemas and storing them in a com‐
mon repository, the messages in Kafka can be understood without coordination.
Schemas and serialization are covered in more detail in Chapter 3.

ordering guaranteed only within partition

streaming frameworks: TODO(Kafka streams, Apache Samza, Storm)

cluster controller - responsible for administrative operations across an entire cluster
 - assigning partitions to brokers
 - monitoring broker failures

A partition is owned by a single broker, called *leader* of the partition. The rest own a copy of it in cases of replication

All consumers & producers must connect to the leader.

retention per topic either via b byte limit or time limit

todo The replica‐
tion mechanisms within the Kafka clusters are designed only to work within a single
cluster, not between multiple clusters

The Kafka project includes a tool called MirrorMaker, used for this purpose. At its
core, MirrorMaker is simply a Kafka consumer and producer, linked together with a
queue. Messages are consumed from one Kafka cluster and produced for another.
Figure 1-8 shows an example of an architecture that uses MirrorMaker, aggregating
messages from two local clusters into an aggregate cluster, and then copying that
cluster to other datacenters. The simple nature of the application belies its power in
creating sophisticated data pipelines, which will be detailed further in Chapter 7.

A Zookeeper cluster is called an ensemble

Zookeeper:

tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
initLimit=20
syncLimit=5
server.1=zoo1.example.com:2888:3888
server.2=zoo2.example.com:2888:3888
server.3=zoo3.example.com:2888:3888


root required below 1024 TODO

log.dirs
Kafka persists all messages to disk, and these log segments are stored in the directo‐
ries specified in the log.dirs configuration. This is a comma-separated list of paths on
the local system. If more than one path is specified, the broker will store partitions on
them in a “least-used” fashion with one partition’s log segments stored within the
same path. Note that the broker will place a new partition in the path that has the
least number of partitions currently stored in it, not the least amount of disk space
used in the following situations:
num.recovery.threads.per.data.dir
Kafka uses a configurable pool of threads for handling log segments. Currently, this
thread pool is used:
• When starting normally, to open each partition’s log segments
• When starting after a failure, to check and truncate each partition’s log segments
• When shutting down, to cleanly close log segments
By default, only one thread per log directory is used. As these threads are only used
during startup and shutdown, it is reasonable to set a larger number of threads in
order to parallelize operations. Specifically, when recovering from an unclean shut‐
down, this can mean the difference of several hours when restarting a broker with a
large number of partitions! When setting this parameter, remember that the number
configured is per log directory specified with log.dirs. This means that if num.recov
ery.threads.per.data.dir is set to 8, and there are 3 paths specified in log.dirs ,
this is a total of 24 threads.


Keep in mind that the number of
partitions for a topic can only be increased, never decreased.


Many users will have the partition
count for a topic be equal to, or a multiple of, the number of brokers in the cluster.
This allows the partitions to be evenly distributed to the brokers, which will evenly
distribute the message load. This is not a requirement, however, as you can also bal‐
ance message load by having multiple topics.


If you are sending messages to partitions based on keys,
adding partitions later can be very challenging, so calculate
throughput based on your expected future usage, not the cur‐
rent usage.

- Consider the number of partitions you will place on each
broker and available diskspace and network bandwidth per
broker.
- Avoid overestimating, as each partition uses memory and
other resources on the broker and will increase the time for
leader elections.


If you don’t have this detailed information, our experience suggests
that limiting the size of the partition on the disk to less than 6 GB
per day of retention often gives satisfactory results.


Note before this the authors talk about throughput: e.g. 20 partitions that can each consume 50MB/s to reach the target throughput of 1GB/s

Retention by time is performed by examining the last modified
time (mtime) on each log segment file on disk. Under normal clus‐
ter operations, this is the time that the log segment was closed, and
represents the timestamp of the last message in the file. However,
when using administrative tools to move partitions between brok‐
ers, this time is not accurate and will result in excess retention for
these partitions.


log.retention.bytes applies to a partition

log.segment.bytes 
  - messages are stored on a partition in segments to improve I/O. when a segment is filled it is closed and kept for log.retention.ms time
  - this makes log.segment.bytes very important depending on how much data we get per time, if misconfigured, data that is set to last for 10 days can last for a year

log.segment.ms - close the segment after ms time

message.max.bytes - default 1MB. High values are risky. Needs to be coordinated with fetch.message.max.bytes on consumer side

vm.swappiness= the % (1-100) of remaining memory after which the OS will start using swap space, default 60. 0 means never swap even if there is swap space

```$ sysctl vm.swappiness=1```

vm.dirty_background_ratio=10
vm.dirty_ratio=20

(default values)

When no of dirty pages reaches 10% then I/O starts to be done but apps can still do non-blocking writes. When it reaches 15% apps can only write synchronously(synchronized) until % gets lower 

e.g. decent for Kafka: dirty_background_ratio 5, dirty_ration 60-80

to check vm vals ```$ cat /proc/sys/vm/swappiness```
 
When choosing values for these parameters, it is wise to review the number of dirty
pages over time while the Kafka cluster is running under load, whether in production
or simulated. The current number of dirty pages can be determined by checking
the /proc/vmstat file:

```$ cat /proc/vmstat | egrep "dirty|writeback"```

FS choice: Ext4 vs XFS

File metadata contains: ctime (creation time), mtime (modified time), atime (last access time) -> set ``noatime`` mount option

```
net.core.wmem\_default
net.core.rmem\_default
net.core.wmem\_max
net.core.rmem\_max

net.ipv4.tcp\_wmem
net.ipv4.tcp\_rmem

net.ipv4.tcp\_window\_scaling
net.ipv4.tcp\_max\_syn\_backlog
net.core.netdev\_max\_backlog
```

See Narkhede Shapira Palino - Kafka - The Definitive Guide/Ch2/Kafka Closters/OS Tuning


Java vm config:

If using Garbage First (G1) collector: 

 - MaxGCPauseMillis - G1 does it estimatively, default 200ms
 - InitiatingHeapOccupancyPercent - heap space percentage until GC starts gcing default 45%

Kafka ex: 20ms and 34%

Kafka is not datacenter aware.

## Producers

Errs thrown in producer: SerializationException, BufferExhaustedException, TimeoutException if buffer is full, or InterruptException if sending thread got interrupted

Important producer conf:

| ---------------- | ---------------------------------------------  |
| acks             | no of partitions required before success       |
| buffer.memory    | message buffer                                 |
| max.block.ms     | how long the thread blocks when waiting for ``send()`` or explicit metadata request using ``partitionsFor()`` |
| compression.type | snappy/gzip/lz4                                |
| retries          |                                                |
| retry.backoff.ms | set to how long it takes for server to reelect |
| batch.size       | bytes, not count, half-full works              |
| linger.ms        | kafka sends buffered messages as soon as there is an available thread to do it, this makes the thread wait for a bit more so that more messages can be shipped |
| client.id        | used in logging, metrics, quotas               |
| timeout.ms       | how long it should take for in-sync replicas to ack |
| request.timeout.ms | how long it waits for a reply from server (leader I assume TODO) |
| metadata.fetch.timeout.ms | timeout duration for when requesting metadata like current leaders for the partitions we are writing to |
| max.request.size | how big a batch can be, this caps the message too |
| max.in.flight.requests.per.connection | how many messages can be sent without receiving a response from the server, 1 means messages keep their order |
| receive.buffer.bytes & send.buffer.bytes | TCP socket buffers, -1 means OS values |


## Consumers

The way consumers maintain membership in a consumer group and ownership of
the partitions assigned to them is by sending heartbeats to a Kafka broker designated
as the group coordinator (this broker can be different for different consumer groups).

**Different from book** Consumers heartbeat from a separate thread. Heartbeating is related to session.timeout.ms

Livelock is handled through max.poll.interval.ms and max.poll.records. request.timeout.ms has to be > than max.poll.interval.ms

The first consumer to send a JoinGroup request becaomes the group *leader* and receives a list of all consumers in the group from the group coordinator. 
It then reassigns the partitions using an impl of ``PartitionAssigner`` After deciding, it sends the assignments to the Group Coordinator which sends the info
to the rest of the consumers. Only the leader has the list of all other consumers, the others only know themselves and their partitions.

Can use regexp in topic names, most often found in consumers that replicate data between kafka and another system.

Important consumer conf:

| -------------------------- | -------------------------------------------------- |
| fetch.min.bytes            | how much data to get at min in one fetch           |
| fetch.max.wait.ms          | how much to wait if fetch.min.bytes is not reached |
| max.partition.fetch.bytes  | how much data the server sends from each partition at most, it should me higher than max.message.size so that you can get more messages |
| session.timeout.ms         | duration after which to d/c if consumer didn't send any heartbeat |
| auto.offset.reset          | where to continue from if the consumer has been disconnected for a long time and its offset has been aged out by the broker, default *latest*, can be *earliest* otherwise|
| enable.auto.commit and auto.commit.interval.ms | commits are done in a separate thread in bulk |
| partition.assignment.strategy | ``PartitionAssignor`` implementations. Available strategies: ``Range``, ``RoundRobin``. Range: C1 and C2, T1 and T2, 3 partitions each, C1 gets part-0 and 1 from both T1 and T2, RoundRobin balances them out accross topics |
| partition.assignment.strategy | can be own impl -> full class pathname | 
| max.poll.records | how many records poll should get, at most | 
| max.poll.interval.max | prevents livelock, how much time the consumer has to finish all its messages from one poll |
| receive.buffer.bytes and send.buffer.bytes | TCP send and receive buffers, default to OS values if set to -1, when latency is high, higher buffers are recommended |

### Commits and offsets

Offsets are done by sending a message to a special __consumer_offsets topic where offsets for each partition are kept. 

If the commited offset is smaller than the offset of the last message the client processed, the messages between the last processed offset and the commited offset will be processed twice

If the commited offset is larger than the offset of the last message the client actually processed, the messages between the last processed offset and the commited offset will not be actually processed.

#### AutoCommit

After auto.commit.interval.ms passes, the last offset received in poll() is commited. close() also commits last received offset.


``seek()`` on partition reassignment + storing offset in a store to set up exactly-once.

``WakeupException`` by calling ``consumer.wakeup()`` -> interrupt call that starts/stops the consumer.

Groupless consumers - for when you want to assign yourself to partitions and not subscribe to them, complete freedom ;)

``ConsumerRebalanceListener`` to handle rebalances

# Kafka internals

Each broker registers itself with its unique id in Zookeeper using an ephemeral node. Components subscribe to the /brokers/ids path.

Id's are kept in other places as well, so if a broker dies it can be replaced by another that has "same" data.

The first broker that starts in the cluster becomes the controller by creating an ephemeral node in ZooKeeper called /controller. The other brokers try to do the same thing but get an exception, then they put a watch on the node to receive changes.

Each time the controller changes ZK increments a *controller epoch* so that old brokers don't do stupid stuff based on the old epoch.

When the controller notices that a broker id disappeared it knows that all the partitions that had a leader on that broker will need a new leader and chooses a replica of the old broker.

When the controller notices that a broker joined the cluser, it uses the broker id to check if there are replicas that exist on this broker, if there are, the controller notifies both new and existing brokers of the change, and the replicas on the new broker start
replicating messages from the existing leaders.

Controller epoch + ZK prevents split brain situations.

## Replication

Leader replica, Follower replica. Leader receives requests from producers/consumers. Followers don't receive client requests.
Followers pull (do Fetch requests), same as consumers, but piecewise, atomically, so that the leader can know which messages got consumed (replicated) and which replica is up-to-date.

Replicas can get out of sync if they haven't requested messages in the last 10s (out-of-sync) and can no longer become a the new leader. In-sync replicas can become leader.

See replica.lag.time.max.ms 

Each partition has a *preffered leader* - the replica that was the leader when the topic was originally created. When partitions are first created, the leaders are balanced beteen brokers
=> when the preffered leader is also the real leader the system is load balanced properly. ``auto.leader.rebalance.enable=true`` makes it so that if the preferred leader is in-sync with 
the leader then leader election is triggered to make the preffered leader the current leader.

The best way to identify the current preferred leader is by looking
at the list of replicas for a partition (You can see details of partitions
and replicas in the output of the kafka-topics.sh tool. We’ll dis‐
cuss this and other admin tools in Chapter 10.) The first replica in
the list is always the preferred leader.

## Request processing

Request standard header:

 - Request type (API key)
 - Request version
 - Correlation ID - unique identifier for the request
 - Client ID - identify the app that sent the request

For each port the broker listens on, the broker runs an *acceptor* thread that creates a connection and hands it over to a *processor* (also called *network threads*) thread for handling.
No. of network threads is configurable. '

Network threads are responsible for taking requests from client connections, placing them in a *request queue*, and picking up responses from a *response queue* and sending them back to clients.

Once requests are placed on the request queue, *IO threads* pick them up and process them.

Most common request types are: Produce and fetch (consumers + replicas)

Clients get information about the leader using a *Metadata request* with the topics they are interested. This can be sent to whichever broker, since they all cache this data and the answer contains per topic info: partitions, leaders.
This metadata gets cached on the client and refreshed based off of metadata.max.age.ms config or if the client receives the "Not a Leader" error to one of its requests.

When the partition leader receives a produce request:
 
 - check write privileges
 - number of acks is valid?
 - if acks is set to all, are there enough in-sync replicas for safely writing the message? TODO config
 - write messages to disk. On Linux they are written to the FS cache and there is no guarantee to when they are actually persisted to the disk, so message durability is enforced through replication instead.
 - once all required acks are received it will send a response to the client

When requesting messages Kafka uses a zero-copy method so that data is sent directly to the network-channel without using a buffer for improved performance.

If a message exists but is not replicated enough the partition leader sends an empty response instead of an error.

When allocating partitions accross brokers partition size is not taken into consideration!!! Newer versions of Kafka can be Rack-aware.

Messages are written to log segments the same way they are received and sent.

If a producer is sending compressed messages, all the messages in a single batch are compressed together and sent as the "value" of a "wrapper message".

```
$ bin/kafka-run-class.sh kafka.tools.DumpLogSegments
```

Log segments are indexed for faster read. If indexes get corrupted a new one is created, it is completely safe to delete index segments.

Retention policy can be set from delete to compact, so that the last value for a key is always kept.


Verifying Kafka:

``org.apache.kafka.tools`` package: ``VerifiableProducer`` and ``VerifiableConsumer``

Tests to run:

 - leader election: duration for producer and consumer, does it work?
 - controller election: how long it takes to resume
 - rolling restart: restart brokers one by one without losing messages
 - unclean leader election test: kill all replicas one by one and then start an out-of-sync broker.

See https://github.com/apache/kafka/tree/trunk/tests

Failure conditions to test against:

 - Clients lose connectivity
 - Leader election
 - Rolling restart of brokers/consumers/producers

Burrow = consumer lag checker by LinkedIn

Coupling -> as little as possible pls.

TODO pag 140 - Coupling and Agility - loss of metadata

MirrorMaker, if SSL'd put closer to source since it is there is only one producer also, you need to send it encrypted. Better to encrypt on consumer. Otherwise put MirrorMaker closer to destination, since you can lose less data that way, maybe consume twice, but at least produce once.

Could use 2 MirrorMakers one on source, one on dest, in same group.


https://eng.uber.com/ureplicator/

kafka-console-consumer formatters: 

 - ``kafka.tools.LoggingMessageFormatter``: prints msg at info level: timestamp, key, value
 - ``kafka.tools.ChecksumMessageFormatter``
 - ``kafka.tools.NoOpMessageFormatter``
 - ``kafka.tools.DefaultMessageFormatter`` has --property options:
   - print.timestam
   - print.key
   - key.separator
   - line.separator
   - key.deserializer
   - value.deserializer - use CLASSPATH env variable to add Java class to classpath




