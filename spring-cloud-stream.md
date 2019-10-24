# Spring Cloud Stream

## Core

``@StreamListener``

 - can be used on multiple functions but they need 2 have return type void
 - if only one, can use ``@SendTo`` to be specific
 - multiple func - same thread execution, no specific order
 - multiple func - can specify condition but the payload is in ``byte[]`` form
 - multiple func - headers are accessible, e.g. ``condition = "headers['type']"=='dog'``

```
@Input
PollableMessageSource destIn();
```
Thread.sleep()/cron stuff

Error Handling - see doc for specific middleware or use ``@ServiceActivator`` ``@Transformer`` etc.

Can have a global error handler by using ``@ServiceActivator("errorChannel")``

DefaultMessageHandlerMethodFactory - see this for custom Message handling and Message conversion(HandlerMethodArgumentResolver, MessageConverter)
