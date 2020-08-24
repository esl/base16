Base16 encoding and decoding
============================

API
---

Both `encode/1` and `decode/1` functions are of `(binary()) -> binary()` type.

The usage looks like:

```erlang
B = crypto:rand_bytes(10).
H = base16:encode(B).
B = base16:decode(H).
```

Please, note:

   * `base16:encode/1` returns lower-case letters.
   * `base16:decode/1` requires the argument to be a binary of odd-number size, and it parses both
     in upper-case or lower-case encoding.


Implementation
--------------

Code is implemented using lookup tables, which tremendously speeds-up the algorithm and consumes
constant memory. It's the fastest you can get using pure Erlang code!


License
-------

The library itself is licensed under the MIT License.

The tests, due to dependency on [PropEr], are licensed under the GPLv3 license.

[PropEr]:http://proper.softlab.ntua.gr/index.html
