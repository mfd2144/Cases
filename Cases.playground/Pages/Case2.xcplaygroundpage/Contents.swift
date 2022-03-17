
//MARK: I believe having two different dictionary classes is a better option than one dictionary class. In modern Swift we can achieve this with a let or var declaration. However, if a mistake is made during coding, it may cause irreversible errors that will affect the entire structure. Of course, this comes at an extra cost. In many cases the object needs to be copied twice. But it provides us a safer coding environment. Immutable dictionaries are completely thread-safe. They can be iterated from multiple threads at the same time without any risk of mutation. And immutable dictionaries provide better performance because the system knows it only needs to allocate a certain size of memory to maintain it.

