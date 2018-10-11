# HADOOP

 - common
 - HDFS
 - YARN
 - MapReduce


## YARN

 - ApplicationMaster - main orchestrator
 - REST API for management and deploy of services
 - YARN DNS server
 - https://hortonworks.com/blog/first-class-support-long-running-services-apache-hadoop-yarn/

### Structure

 - Application Client - sends the a req to a ResourceManager
 - ResourceManager - one per cluster
 - NodeManager - one per node 
 - Container - Unix process or Linux cgroup

## MapReduce
 
 - Map (key, value) -> (key2, value2)
 - Reduce (key, value: ? extends Iterable) -> result (=?? TODO) i think it can be (key2, value2) but can it be sth else?

## HDFS

 - large blocks usually (128 MB) so that there are fewer seeks to start of block and transferring data operates at disk transfer rate
 - NameNode - in-memory
 - Master-Slave NameNode - DataNode
 - read/write/append/rename. No random access write
 - streaming data
 - replication factor can be managed per-file
 - file permissions x is ignored for files, x for directory means it can be accessed

### AVRO

Schema used to read data needs not be identical to the schema that is used to write the data. Each app can use its own schema.

Avro is compressable and splittable.

Java mapping - Specific - domain oriented when you have the schema, Generic (int, bool etc.), Reflect

### Parquet

Column-oriented. Can handle deeply nested structures

### NameNode Replication

 - atomic write to an NFS mount
 - secondary namenode which despite name isn't a NameNode, instead it periodically merges the namespace image with the edit log to p
revent the edit log from becoming too large
 - there is a way to keep a hot standby namenot instead of a secondary
 - NameNode is su for all files

#### NameNode High Availability (HA)

 - NameNodes must use HA shared storage to share the edit log.
 - DataNodes must send block reports to both namenodes
 - Clients must be configured to handle namenode failover, using a mechanism that is transparent to users

### Block Caching

 - blocks can be explicitly cached in an TODO (off-heap) block cache. By default it is done ony in one datanode's memory, number configurable in a per-file basis
 - caching can be configured using *cache directives* on a *cache pool*. Cache pools are an administrative grouping for
managing cache permissions and resource usage

TODO: https://hortonworks.com/tutorial/hadoop-tutorial-getting-started-with-hdp/section/1/ 3.3 Apache Yarn, Resource Manager, Application Master, etc.

### Hadoop Filesystems

See org.apache.hadoop.fs.FileSystem

 - Local, fs.LocalFileSystem, locally connected disk
 - HDFS
 - WebHDFS, hdfs.web.WebHdfsFileSystem, authenticated rw over HTTP
 - SecureWebHDFS hdfs.web.SWebHdfsFileSystem, authenticated rw over HTTPS
 - HAR, fs.HarFileSystem, Hadoop archives
 - View, see HDFS Federation
 - S3 - for S3 backed FS
 - Azure - for Azure backed FS
 - Swift - for OpenStack Swift backed FS

``RawLocalFileSystem`` doesn't use client checked checksums, unlike ``LocalFileSystem``(and maybe others).

``ChecksumFileSystem(FileSystem)`` decorator

Default implementation for ``ChecksumFileSystem`` does nothing on bad chksm, however ``LocalFileSystem`` moves the offending file and its checksum to a side directory on the same device called *bad_files*



Anatomy of write. Create from client -> namenode creation -> write on connected node -> connected node sends to replica 2 -> replica 2 sends to replica 3 -> all nodes asynchronously send an ack packet to the node/client that emmited the request until the client gets all the replicas to ack.

If a datanode fails the write pipeline is closed and the packets in the ack queue are added in front of the data queue so that the datanodes that are downstream from the failed node will not miss any packets. The current block on the good datanodes is given a new identity, which is communicated to the namenode and the partial block written on the failed datanode will be deleted upon recovery. Ultimately the failed datanode will be reconstructed using the other datanodes on recovery.

The write succeeds as long as dfs.namenode.replication.min replicas are written.

Closing the stream is successful only when all required data-nodes are consistent.

See **hadoop** utility for interactions with fs using cli

#### Coherency

Any content written to a file is not guaranteed to be visible even if the stream is flushed. Once more than a block's worth of data has been written the first block will be visible, the current block is always not visible. Forcing a flush can be done using FSDataOutputStream.hflush() which guarantees that the write is in memory, not that it's actually persisted.

Closing the fos guarantees that it is flushed using hflush()

To assure synchronization of persisted data use hsync()

# HIVE

Built on the MapReduce framework, Hive is a data warehouse that enables easy data summarization and ad-hoc queries via an SQL-like interface for large datasets stored in HDFS.

SQL stuff including CTE

TODO I think it can use both MapReduce and Tez

Apache ORC file (optimized row columnar) optimized for Hive ``CREATE TABLE <tablename> ... STORED AS ORC ...``

``beeline`` for interactive jdbc connection from ssh web client/ssh(TODO i think)

TODO: vectorization??

## HCatalog

 - file paths + metadata in a Cluster

## UDF - user defined function
 
 Use Java JARs on HDFS to add user defined functions

# Apache Tez

 - MapReduce for directed acyclic graphs???
 - write native YARN apps, high performance, > MapReduce, used by Hive, Pig, Cascading etc.

# Pig

A platform for processing and analyzing large data sets. Pig consists of a high-level language (Pig Latin) for expressing data analysis programs paired with the MapReduce/Tez framework for processing these programs.

 - ETL
 - research
 - iterative data processing
 - describe complex flows
 - can be extended with UDF

Has 2 modes, local and MapReduce

# Spark

In-memory data processing, iterative algo(clustering, etc.)

 - RDD - resilient distributed dataset
 - transforms are lazy

# Storm

Real-time processing of large data for Hadoop2





# HBase

Column-oriented NoSQL

# Kafka

Pub-sub

## Slider

Deploy/manage long-running data access apps in Hadoop using YARN.

## Accumulo

data storage & retrieval with cell-level access control

#NiFI & MiNiFi


