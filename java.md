


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

Each wildcard is refers to a different "any" type.

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





