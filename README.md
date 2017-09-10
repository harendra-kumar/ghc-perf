This is on GHC 8.2.1. Performance with manually inlining a function is more
than 10% faster compared to factoring out code and using INLINE pragma.

* `stack bench` for compiler inlined code

```
time                 46.71 ms   (45.53 ms .. 47.79 ms)
```

* `stack bench --flag ghc-perf:manual` for manually inlined code

```
time                 39.46 ms   (38.92 ms .. 39.94 ms)
```
