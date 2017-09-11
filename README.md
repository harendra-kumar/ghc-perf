* Run `stack bench` to run the default and `-O0` benchmarks. `-O0` turns out to
  be twice as fast compared to the default case. Note that `-O2` is the same as
  default.

* Run `stack runghc Main.hs` and it turns out to be twice as fast as `-O0`,
  i.e. 4 times faster than the default or `-O2`.

This is on GHC 8.2.1
