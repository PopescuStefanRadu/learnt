# Java
 
## Concurrency

### Liveness

 - deadlock, starvation, livelock

 - Reentrancy means that locks are acquired 
on a per-thread rather than per-invocation basis 

 - Reentrancy lock counter per thread 2^32 iirc TODO check

 - out of thin air thread safety - not volatile, but not long or double, 
when synchronized mutation don't require volatile since they are intrinsically atomic

### Visibility

 - While it may seem that field values set in a constructor are the first values written to those fields and therefore that there are no "older"
values to see as stale values, the Object constructor first writes the default values to all fields before subclass constructors run. It is therefore
possible to see the default value for a field as a stale value.

 - volatile - operations are not reordered by the compiler and are not cached 

 - ``-server`` argument runs jvm in a mode that optimizes more aggressively

 - You can use volatile variables only when all the following criteria are met:

   - Writes to the variable do not depend on its current value, or you can ensure that 
only a single thread ever updates the value;

   - The variable does not participate in invariants with other state variables;

   - Locking is not required for any other reason while the variable is being accessed.

 - inner class instances contain a hidden reference to the enclosing instance

 - letting this escape from constructor (or anywhere else) -> 1. object escaping, 
2.possibly not fully instantiated

### Thread confinement

 - Ad-hoc = volatile with serialized atomic changes

 - Stack confinement = local vars are implicitly confined (thread-local vars)
 
 - ThreadLocal = "Like global variables, thread-local variables can detract from reusability
and introduce hidden couplings among classes, and should therefore be used
with care."

 - volatile immutable holders for sharing state + atomic serialized tranformations

 - "To share mutable objects safely, they must
be safely published and be either thread-safe or guarded by a lock."

## Spring

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

 - spring.jpa.properties.hibernate.jdbc.lob.non_contextual_creation=true

# Linux

 - ``ls -d1 $pwd/tmp/* | grep myFile | xargs rm``

# PostgreSQL

## Postgres

 - ``/etc/postgresql/9.6/main/pg_hba.conf`` 
 conexiunile trebuie sa fie start in loc de peer
 
 - ``psql -Uuser -d my_db -W``

## pgsql

 - ``\du`` - show all users 
 - ``\l`` - list databases
 - ``\c dbname`` - connect to db
 - ``\d+ tablename`` - describe table
 - ``\dt`` - show tables

# Intellij

## Code

 - ctrl-shift-A pt search in optiuni etc
 - crtl-alt-m extrage in metoda

## HTML

 - daca scriu li si apas tab atunci imi transforma in <li></li>, etc.
 - . + tab = new div with class

# HTML + CSS

 - outline vs border

# JS

 - Hoisting
 - http://es6-features.org/

## Angular

 - package json
 - ng serve - run
 - npm install --save bootstrap@3 (local, cea mai noua din v3)
 - angular.json -> styles
 - typescript - use single quotes
 - binding 
    - ts -> template: string interpolation; attribute/property binding??
    - html -> ts : event binding
    - ngModel
 - * - directiva structurala??? TODO
 - ng generate component shoes/shoe-edit /// ng g c // --spec=false
 - var str: string; var qty = +str; //conversion to number
 - @ViewChild - ajungi sa faci din component un Session Managed Bean a la JSF
 - ng-content + @ContentChild() pt cand vreau ca directiva sa foloseasca ce 
este in interiorul <app-component-name></app-component-name>
 - https://github.com/angular/angular-cli/blob/v6.0.0-rc.8/packages/%40angular/cli/lib/config/schema.json - angular-ci options for serve, etc.
 - https://github.com/angular/angular-cli/wiki/angular-workspace angular cli schema

# Groovy

## Spock

 - ``@Unroll`` pe test parametrizat
 - -ea -Dselenide.browser=Chrome -Dwebdriver.chrome.driver=src/test/resources/chromedriver_new

# Docker

 - docker commit
