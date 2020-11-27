Available and partition tolerant by default. Can, per query, be 
consistent + partition tolerant

Store together what you query together

Make partitions as even as possible

Avoid big partitions

Avoid hot partitions

Limitations per partition:

 - Up to ~100k rows
 - Up to ~100MB
 - single cell not bigger than ~10MB

timeuuid type



Keyspace is a group of tables sharing some common features todo 

Avoid client-side joins


commands:

```
describe keyspaces;
describe keyspace asd;
describe table asd;
SELECT * FROM killrvideo.users WHERE userid = ff9750ec-4b00-4062-be3f-8a6e17bbca55; // no '' or ""
DELETE email FROM killrvideo.users WHERE userid = c974c45c-c62e-4d9c-bab6-a34fac4451d9;
// COPY import/export from csv

TRUNCATE; // works by deleting all SSTable data!!!


SOURCE <filename>; // executes cql file
```

nodetool:


```
nodetool drain #flush data
```


### Replication:

Strategy: per keyspace;



can be changed via `ALTER KEYSPACE`

caas-dc = replication factor (RF)

local quorum (in my datacenter)

Immediate consistency: 

`Consistency level read + consistency level write > replication factor`

### Write path:

coordinator node -> commit log -> mem table (eventually sstable sorted strings table kv store)

Also replication

It's recommended to have commit log and sstables on different HDDs/SSDs.

Every write has a timestamp.

Deletes are tombstones

SSTables are immutable. They are compacted instead.



Read repair chance. In order to deal with nodes having old data, C\* may hit all replicas
to update things to latest version. read\_repair\_chance is default 10%



### Read path


Assuming read consistency ALL. Coordinator gets data from 1, checksum from 2. Compares checksums,
returns.

Each cell has a timestamp (todo check). If checksums are different coordinator takes the one
with the most fresh timestamp and sends them to the out of date nodes.

dclocal\_read\_repair\_chance = 0.1 - check all nodes on read and repair if necessary. Limited to datacenter

read\_repair\_chance = 0 - read repair across all datacenters


In an SSTable there is data for multiple partitions. An index keeps the file offsets for each partition.
There is also a partition summary which indexes the partition index and resides in RAM.

There is also a bloom filter, which may sometimes know that a key does not reside in the node.

There is also a key cache (in memory), in case the user asks for the same key, the key 
cache keeps the SSTable offset directly.


### Comapction strategy


SizeTiered Compaction - (default) triggers when multiple SSTables of a similar size are present,
great if ingesting a lot of data / write heavy workload

Leveled Compaction - groups SSTables into levels, each of which has a fixed size limi which is 10 times larger than the previous level


TimeWindow Compaction - creates time windowed buckets of SSTables that are compacted with each other using the Size Tiered Compaction Strategy.

Use the ALTER TABLE command to change the strategy.


Tombstones that are older than gc\_grace\_seconds do not get deleted.

```
ALTER TABLE keysp.mytable WITH compaction = {'class':'LeveledCompactionStrategy'};
```




DSE gets rid of all this:

 - no partition summary
 - partition index is changed to a trie-based data structure
 - migration from cassandra is seamless, done during compaction



### Snitch



### bin

nodetool status

2-4 TB per node



### VNodes todo

number of vnodes: num\_tokens in cassandra.yaml


makes add/remove nodes better, especially add if one overloaded node has to stream a lot of data to a new node


default num of vnodes: 128


When using vnodes Cassandra automatically assigns the token ranges for you.



### Gossip

Seed nodes


Only spreads node metadata:

 - Endpoint State (all the gossip state)
   - Heartbeat State:
     - generation = 5 // timestamp when node bootstraped
     - version = 20 // incremented - used to figure out if a node is up or not
   - Application state:
     - status: NORMAL | BOOTSTRAP | REMOVING(REMOVE) - can't physically access the node
     - DC = datacenter
     - RACK = rack
     - SCHEMA = schema version
     - LOAD = disk load


SYN msg: endpoint:generation:version list - says all it knows

ACK msg: enpoint:generation:version list - returns all it knows including outdated stuff

ACK2 - sends data for outdated stuff

### Snitches

Which rack belongs where. Communicate hash ranges?



Types of snitches:


PropertyFileSnitch from cassandra-topology.properties - manually maintained for all nodes

GossipingPropertyFileSnitch - Configure each node to its datacenter and rack and then gossip spreads the info. Configure `dc` and `rack` in cassandra-rackdc.properties file


RackInferringSnitch - infers from ip addr. sth.datacenter.rackoctet.nodeoctet


There are also cloud based snitches.


Also dynamic snitch based on performance.



When changing snitches run repair & cleanup on all nodes. Entire cluster must use same snitch.


REplication factor 0 means only memtable probably, works in a multi-datacenter setup


### Hinted handoff

Coordinator node keeps that that could not reach a downed node until it is up again and streamed
successfully.


in cassandra.yaml

can be disabled

can be stored for x hours (3 default)

choose directory


### Terminology

Data model:

 - abstract model for organizing elements of data
 - based on the queries you want to perform

Keyspace:

 - similar to schema
 - all tables live inside a keyspace
 - is container for replication

Table: 

 - grouped into keyspaces
 - contains columns
 - formed from partitions

Partitions:

 - Row/s of data that are stored on a particular node based on a partitioning strategy



Collections cannot contain other collections unless they are FROZEN (i.e. serialized as a blob)


#### Counters

In some cases counters can be inconsistent.

Cannot insert or assign values - default is 0.

Must be only non-primary key columns (duh!)

Not idempotent (duh!)

Must use UPDATE command, DSE rejects USING TIMESTAMP or USING TTL to update counter cols.

Counter columns cannot be indexed or deleted.


### User defined functions and aggregates TODO (course 220) (UDA, UDF)

#### UDFs

 - can be used in SELECT, INSERT & UPDATE statemtents
 - only available in the keyspace they are defined
 - required setup:
   - cassandra.yaml: `enable_user_defined_functions` to `true` (`enable_scripted_user_functions` for js and others)  

#### UDA

 - custom aggregate function (`select average(avg_rating) from videos where release_year = 2002 allow filtering`)
 - state function called once for each row
 - value returned by state function becomes the new state
 - after all rows are processed, optional final function is executed with last state as arg
 - aggregation is performed by the coordinator


### Data modelling


Conceptual data model + application workflow -> Mapping conceptual to logical -> logical data model -> physical data model -> optimization tuning



#### Conceptual data model

Entities and attributes. Technology independent. Abstract view of domain. Has relationships between entities. Relationships can have attributes.

#### Logical Data model

Table diagrams (primary key, partitioning key, clustering key), UDT diagrams

#### Physical Data model

Add data types

#### Data Modeling Principles

 - Know your data
   - Conceptual model
 - know your queries
 - nest data
   - group data on disk as much as possible
 - duplicate data 

Single partition query - optimal

#### Modeling (Mapping) guideline:

 1. Entities and relationships
 2. Equality search attributes (`select from blah where sth = ?`)
 3. Inequality search attributes (gt, lt, lte, gte)
 4. Ordering attributes (e.g. timestamp descending)
 5. Key attributes (satisfy uniqueness)

### Batches

Batches are written all with the same timestamp, so if you insert then update then delete the same entity
at read, all the sstable values are the latest, so the result is non-deterministic.

Batches guarantee that all instructions are written and eventually persisted.


### Lightweigh TX: compare and set props with ACID

Acid transaction (one write at a time though)

### Secondary indexes

An index that allows a table to be queried on a column that is usually prohibited:

 - Table structure is not affected
 - table partitions are distributed across nodes in a cluster based on a partition key
 - can be created on any column including collections except `counter` and `static` columns

Indexes are kept at a partition level.

When to use:

 - low cardinality columns (few unique values on a column)
 - protoptyping small datasets
 - search on both partition key and indexed column in a large partition


When not to use:

 - high cardinality columns (many unique values on a column)
 - with tables that use a counter column
 - frequently updated or deleted columns

### Materialized views


Maintains a table with a different primary key.

Primary key from view must contain all of the primary key columns from the base table

Only one new column can be added to the view's primary key!!! (static column not allowed)

If read repair is triggered on base table, both are repaired. If it is triggered on materialized view
only materialized view is repaired.


### Aggregates

SUM, AVG, COUNT, MIN, MAX - calculated at query time


Another way to do aggregates is simply do them on client.


Another way is to maintain them manually in a table.



### Table/Key optimizations


Splitting partitions by redifining partition key if a partition is too large.

Vertical partitioning - splitting table into multiple tables.


### Data model migration


 


### Various

https://docs.datastax.com/en/dsbulk/doc/index.html  recently Open sourcedi




## Client code

Driver is node aware and can send/request data to nodes directly.

## CQLSH


```
describe keyspaces;

describe keyspace test;

use test;

describe keyspace;

use system;

EXPAND ON; -- OFF

create keyspace test2 WITH replication = {'class':'NetworkTopologyStrategy', 'replication_factor': 3};

create keyspace test2 WITH replication = {'class':'NetworkTopologyStrategy', 'DC': 3, 'RO': 2};
-- Note that when ALTER ing keyspaces and supplying replication_factor, 
-- auto-expansion will only add new datacenters for safety, it will not alter existing 
-- datacenters or remove any even if they are no longer in the cluster. If you want 
-- to remove datacenters while still supplying replication_factor, explicitly zero 
-- out the datacenter you want to have zero replicas.


create keyspace test2 WITH replication = {'class':'SimpleStrategy', 'replication_factor': 3};

```



