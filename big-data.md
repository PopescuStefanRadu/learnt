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

## MapReduce

## HDFS

 - large blocks usually (128 MB)
 - NameNode - in-memory
 - Master-Slave NameNode - DataNode
 - NameNode can have an atomic replica TODO
 - read/write/append/rename. No random access write
 - streaming data
 - replication factor can be managed per-file

TODO: https://hortonworks.com/tutorial/hadoop-tutorial-getting-started-with-hdp/section/1/ 3.3 Apache Yarn, Resource Manager, Application Master, etc.

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




