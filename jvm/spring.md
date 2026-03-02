# Spring

ApplicationEventPublisher - neato

AbstractAggregateRoot<T> - registerEvent

https://www.youtube.com/watch?v=WSjj-IhBiSY

#### Annotations boot

importbeandefinitionregistrar

Importselector

SpringFactories (similar to Java ServiceLoader)


## Database


### jooq

https://www.youtoube.com/watch?v=j5QqHSIEcPE
https://www.youtoube.com/watch?v=4pwTd6NEuNo


## Misc notes

 - spring doesn't run PreDestroy on prototype (too damn hard anyway)

 - TODO @Qualifier research

 - "Common application properties"

 - redirect scoate "back-ul"

 - "if we want to pass the attributes via redirect between two 
controllers, we cannot use request attributes 
(they will not survive the redirect), 
and we cannot use Spring's  @SessionAttributes 
(because of the way Spring handles it), only an ordinary 
HttpSession can be used, which is not very convenient." ->
Solution: use RedirectAttributes::addFlashAttributes /TODO check

 - MessageSource i18n

 - spring.jpa.properties.hibernate.jdbc.lob.non\_contextual\_creation=true
