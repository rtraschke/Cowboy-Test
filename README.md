# Cowboy-Test

Just some playing around with Cowboy for testing purposes.


# Load test using Tsung 

```shell
$ curl -O  http://tsung.erlang-projects.org/dist/tsung-1.6.0.tar.gz
$ tar xzf tsung-1.6.0.tar.gz
$ cd tsung-1.6.0
$ ./configure --prefix=`pwd`
$ make
$ make install
$ cd ..
$ tsung-1.6.0/bin/tsung -f tsung/tsung.xml -l tsung/log start
Starting Tsung
Log directory is: .../tsung/log/20170822-1414
...
$ cd tsung/log/20170822-1414
$ ../../../tsung-1.6.0/lib/tsung/bin/tsung_stats.pl --dygraph
$ open report.html
```

The above is encapsulated in the `run-tsung` make target.

Possible pre-requisites
```shell
$ sudo cpan Template::Toolkit
```

The Tsung [sample report](https://rtraschke.github.io/Cowboy-Test/tsung/sample/report.html) for ramping from 200 through to 450 new requests per second on my MacBook Pro (2 GHz Core i7, 16GB), running the Cowboy Test server and the Tsung test on the same machine (Erlang 19.3, ulimit -n 9000), is not very representative.
