Base16 encoding and decoding
============================

[![Actions Status](https://github.com/esl/base16/workflows/ci/badge.svg)](https://github.com/esl/base16/actions)
[![codecov](https://codecov.io/gh/esl/base16/branch/main/graph/badge.svg)](https://codecov.io/gh/esl/base16)
[![Hex](http://img.shields.io/hexpm/v/base16.svg)](https://hex.pm/packages/base16)

## API

Both `encode/1` and `decode/1` functions are of `(binary()) -> binary()` type.

The usage looks like:

```erlang
B = crypto:rand_bytes(10).
H = base16:encode(B).
B = base16:decode(H).
```

Please, note:

   * `base16:encode/1` returns lower-case letters.
   * `base16:decode/1` requires the argument to be a binary of odd-number size, and it parses both in upper-case or lower-case encoding.


## Implementation

Code is implemented using lookup tables, which tremendously speeds-up the algorithm and consumes constant memory. It's the fastest you can get using pure Erlang code!

## NOTE

Note that, lookup tables also means that the code-size is bigger.
If you're running on embedded, where smaller code-sizes are the actual best, you might benefit from using the version 1.0.0, both available on github and hex.


License
-------

The library itself is licensed under the MIT License.

The tests, due to dependency on [PropEr], are licensed under the GPLv3 license.

[PropEr]:http://proper.softlab.ntua.gr/index.html
