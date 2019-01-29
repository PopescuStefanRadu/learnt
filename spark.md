RDD persistence:

 - MEMORY\_ONLY - unserialized
 - MEMORY\_ONLY\_SER - serialized
 - MEMORY\_AND\_DISK
 - MEMORY\_AND\_DISK\_SER
 - DISK\_ONLY
 - add \_2 to store on 2 machines

unpersist to evict manually. TODO is it necessary?

The textFile method also takes an optional second argument for controlling the number of partitions of the file. By default, Spark creates one partition for each block of the file (blocks being 64MB by default in HDFS), but you can also ask for a higher number of partitions by passing a larger value. Note that you cannot have fewer partitions than blocks.

SparkContext.wholeTextFiles lets you read a directory containing multiple small text files, and returns each of them as (filename, content) pairs. This is in contrast with textFile, which would return one record per line in each file.

``coalesce`` vs ``repartition``, coalesce always reduces partitions so a bit less data movement, always use coalesce when parallelism gets <.

 - reducers: groupBy* 
