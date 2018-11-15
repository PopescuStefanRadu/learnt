max.poll.records + max.poll.interval.ms - max number of records received in a poll, if a consumer cannot finish consuming all the messages in that poll during max.poll.interval.ms then it will be considered failed -> rebalancing -> consumer was fine and now re-registers itself -> rebalancing again. This can lead to multiple message consumption duplicates

kafka - distributed commit log / distribute streaming platform

can have keys - in order to split data in partitions in a controlled manner

messages are sent/received usually in batches

