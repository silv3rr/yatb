# Yet Another Traffic Bouncer

## COMPILING

If you've installed OpenSSL as package just runnning `make linux` should work

If you compiled OpenSSL from source into '/usr/local', use the oneliners for your OS below

In case you used some other method to install OpenSSL, set environment variables accordingly

* `PREFIX` base directory used in variables 
* `OPENSSL_BIN` path to 'openssl' binary
* `LDFLAGS` linker libraries
* `LD_LIBRARY_PATH` needed to run openssl binary
* `CPPFLAGS` C preprocessor includes

### Debian 

* Make: `PREFIX="/usr/local" LDFLAGS="-L${PREFIX}/lib" LD_LIBRARY_PATH="${PREFIX}/lib" OPENSSL_BIN="${PREFIX}/bin/openssl" make linux`
* Run: `LD_LIBRARY_PATH=/usr/local/lib ./yatb yatb.conf`

### CentOS

* Make: `PREFIX="/usr/local" LDFLAGS="-L${PREFIX}/lib64" LD_LIBRARY_PATH="${PREFIX}/lib64" OPENSSL_BIN="${PREFIX}/bin/openssl" make linux`
* Run: `LD_LIBRARY_PATH=/usr/local/lib64 ./yatb yatb.conf`

### Wrapper

Or, create a little 'yatb.sh' wrapper script:

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

