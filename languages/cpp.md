```
void increment() {
	int v[] = {0,1,2,3,4,5,6,7,8,9};
	for (auto& x : v)
	++x;
	// ...
	// add 1 to each x in v
}
```

A reference is similar to a pointer, except that you don’t need to use a 
prefix ∗ to access the value referred to by the reference. Also, a 
reference cannot be made to refer to a different object after 
its initialization.




