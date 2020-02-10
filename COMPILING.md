# Yet Another Traffic Bouncer COMPILING

## Make

Always `make clean` first.

If you've installed OpenSSL as package just runnning `make linux` should work.

If you compiled OpenSSL from source into '/usr/local', use the oneliners for your OS below.

In case you're on a different OS and/or used some other method to install OpenSSL you have set environment variables accordingly.

* `PREFIX` base directory used in variables 
* `OPENSSL_BIN` path to 'openssl' binary
* `LDFLAGS` linker libraries
* `LD_LIBRARY_PATH` needed to run openssl binary
* `CPPFLAGS` C preprocessor includes

Make will first run `openssl dhparam -noout -C 2048 >>include/tls_dh.h`

We want to be sure 'make' can find the openssl binary and dependent shared libraries. This is why OPENSSL_BIN and LD_LIBRARY_PATH need to be set.

To run yatb LD_LIBRARY_PATH also needs to be set. You can print the libs required by runing `ldd yatb`.

### Debian

First compile:

`PREFIX="/usr/local" LDFLAGS="-L${PREFIX}/lib" LD_LIBRARY_PATH="${PREFIX}/lib" OPENSSL_BIN="${PREFIX}/bin/openssl" make linux`

Then start yatb:

`LD_LIBRARY_PATH=/usr/local/lib ./yatb yatb.conf`

### CentOS

`PREFIX="/usr/local" LDFLAGS="-L${PREFIX}/lib64" LD_LIBRARY_PATH="${PREFIX}/lib64" OPENSSL_BIN="${PREFIX}/bin/openssl" make linux`

`LD_LIBRARY_PATH=/usr/local/lib64 ./yatb yatb.conf`

### Wrapper

For starting you could also create a small 'yatb.sh' wrapper script:

``` bash
#!/bin/sh
if [ -x "yatb" ]; then
  ARGS="yatb.conf"
  if [ -n "$@" ]; then
    ARGS="$@"
  fi
  # For CentOS change lib to lib64
  LD_LIBRARY_PATH="/usr/local/lib" ./yatb "$@"
fi
```
