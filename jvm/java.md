# Java

## Streams

 - ``Predicate`` ``.and`` and ``.or`` are evaluated in a chain from left to right :( 
 
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

 - Immutable objects can be used safely by any thread without additional synchronization, even when synchronization is
not used to publish them
 - Safe publication 
   - Initializing in ``static``
   - Storing in ``volatile`` or ``AtomicReference``
   - Storing in ``final`` field of a properly constructed object
   - Storing reference in a field that is properly guarded by a lock

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

## Generics Madness


### General Generics

Exceptions cannot be generic.



### Casting Couch

Cast:

1. Static type check at compile time
2. Dynamic type check at runtime by VM (can result into a ClassCastException)

Conversions between primitives do not require casts, nor do upcasts.

Concrete Parameterized Type = instantiation of generic type where all type parameters are concrete, rather than wildcards


### Variance

#### Theory

Covariance - Subtype can be used as a Supertype

Contravariance - Supertype can be used as a Subtype

Bivariance - Both apply

Variance - any variance applies

Invariant/nonvariant - none



#### Practice

ArrayList<Object> can be cast to Collection<Object> -- for same type argument things are normal/covariant


To have different argument types you need to use wildcards, and the specified limitation must apply.


##### Arrays


They are covariant but carry runtime validation so that no bullshit seeps in(**homogeneous**). Even when you use them by
supertype it is the runtimetype that checks for correct usage.


```Java
Object[] xs = new String[10];
xs[0] = Long.valueOf("1"); // ArrayStoreException
```

Since at runtime we have no idea of the generic type arrays cannot be of a parameterized type (including concrete)

```Java
Pair<Integer, Integer>[] intPairArr = new Pair<Integer,Integer>[10]; // illegal
Object[] objArr = intPairArr;
objArr[0] = new Pair<String, String>("",""); // here it should fail because of the runtime checks with ArrayStoreException, but VM has no info of this
```

"?" without bounds symbolizes the type we expect a parameterized array type to have, so it is permitted.

###### Reifiable types are permitted as component type of arrays.

```Java
class Name extends Pair<String, String> {}

Pair<String, String>[] arr = new Name[2]; // reified via Name type


void extractStringPair(Pair<String,String>[] arr) {
  Name name = (Name)arr[0]; //fine
}
```

Using `Pair<String,String>[]` gives no real advantage to using `Name[]`.


###### Dealing with no concrete parameterized types on array components

1. Arrays of raw types
2. Arrays of unbounded wildcard parameterized types
3. Collections of concrete parameterized types as a workaround


###### Wildcard on arrays

Ensures that the Array is homogeneous. Only safe operations are possible on components.

##### Collections

Collections of concrete parameterized types are homogenous.


### Type erasure

```Java
interface Copyable<T> {
  T copy();
}

final class Wrapped<Elem extends Copyable<Elem>> {
  private Elem theObject;public Wrapped(Elem arg) { theObject = arg.copy(); }

  public void setObject(Elem arg) { theObject = arg.copy(); }

  public Elem getObject() { return theObject.copy(); }

  public boolean equals(Object other) {
    if (other == null) return false;
    if (! (other instanceof Wrapped)) return false;
    return (this.theObject.equals(((Wrapped)other).theObject));
  }
}
```

to:

```Java
interface Copyable {
  Object copy();
}

final class Wrapped {
  private Copyable theObject;

  public Wrapped(Copyable arg) { theObject = arg.copy(); }

  public void setObject(Copyable arg) { theObject = arg.copy(); }

  public Copyable getObject() { return theObject.copy(); }

  public boolean equals(Object other) {
    if (other == null) return false;
    if (! (other instanceof Wrapped)) return false;
    return (this.theObject.equals(((Wrapped)other).theObject));
  }
}
```

If the method's argument type is not changed by type erasure, then the method call is safe.


### Wildcard

Each wildcard refers to a different "any" type.

todo

Creating objects of wildcard parameterized type. You can't specify it in RHS, in RHS you always(todo or so it seems) need a concrete type

Using wildcard as the LHS of `new` and such makes very little sense imo, always better to use a more specific type.

Creating an array of a wildcard parameterized type is not possible directly. Same argument as for concrete parameterized types: They are not reifiable. Only ? alone is reifiable, but of little value.

You can create an array of reified type that respects your wildcard conditions(from LHS). Beware that, as usual, the VM will check at
compile time to see if you are respecting the reified captured type and WILL throw an `ArrayStoreException`



#### You can create an array whose component is an unbounded wildcard parameterized type:

```Java
Object[] pairArr = new Pair<?,?>[10];
pairArr[0] = new Pair<Long, Long>(0L,0L);
pairArr[1] = new Pair<String,String>("","");
pairArr[2] = new ArrayList<String>(); // obvious runtime ArrayStoreException
```

similar to

```Java
Pair<?,?>[] arr = new Pair<?,?>[2];
```

but not

```Java

Pair<? extends Number, ? extends Number>[] arr = new Pair<? extends Number, ? extends Number>[2]; // Compile time error 
// how can the compiler enforce this?
// same for a Pair<Double,Double>[], etc.
```


#### You cannot derive from a wildcard parameterized type

```Java
class MyClass implements Comparable<?> {
  public int compareTo(??? arg) {return 0;} // ? here would mean a function that can compare any MyClass of Something 
// to ablsolutely everything else(like runtime else). It makes no sense.
}
```

use `Comparable<Object>` instead, `compareTo` is a function that takes Object, it's covariant, it will take any
subtype of Object


#### Class literal

Same as concrete parameterized types (`Pair<SthConcrete,SthElseConcrete>`) it has no runtime type representation,
it's simply a compile time helping hand. It gets type erased.


### Generic methods

### QA

#### Concrete parameterized type vs simple types are similar but cannot be used for:

 - creation of arrays
 - exception handling
 - in a class literal
 - in an instanceof expression

#### Rawtype vs unbounded wildcard parameterized type

 - both reifiable (e.g. can be used as an argument to *instanceof*)
 - on raw type compiler issues warnings, on unbounded wildcard they are compile errors

#### Wildcard parameterized type vs other types

? Can be used for typing:

 - argument and return types of methods
 - field type or local reference variable
 - type argument of other parameterized types
 - target type in casts

? can **NOT** be used for(Unlike non-parameterized classes & interfaces):

 - creation of objects
 - creation of arrays(except unbounded wildcard)
 - exception handling
 - `instanceof` expressions (except unbounded wildcard)
 - as supertypes
 - in a class literal (?.class, kind of stuff)


### Type parameters

 - array types are not permitted as bounds `T extends Object[] // err`
 - primitive types not permitted as bounds

Cannot use different instantiations of same generic type as bounds of a type param:

```
class Foo<T extends Comparable<T> & Comparable<String>> // error
```
