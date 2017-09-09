* Run `stack bench` to run the `-O2` and `-O0` benchmarks. `-O0` turns out twice as fast
  as `-O2`

* Run `stack runghc Main.hs` and it turns out to be twice as fast as `-O0`, i.e. 4
  times faster than `-O2`.

This is on GHC 8.2.1
