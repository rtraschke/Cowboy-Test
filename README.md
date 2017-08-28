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


Setup an AWS EC2 (ami-a8d2d7ce)

```
sudo sh -c "cat >>/etc/security/limits.conf" <<EOF
* soft nofile 524288
* hard nofile 524288
EOF
sudo sh -c 'echo "1024 65535" >/proc/sys/net/ipv4/ip_local_port_range'
```

Log out and back in.

```
ulimit -n
sudo apt-get -qq -y update
sudo apt-get -qq -y install gcc g++ make unixodbc unixodbc-dev libncurses5-dev openssl libssl-dev git
sudo sh -c 'echo | cpan Template::Toolkit'
curl -s https://01234567-hostedgraphite-uuid@www.hostedgraphite.com/agent/installer/deb/ | sudo sh
curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x kerl
./kerl update releases
./kerl build 19.3 19.3
./kerl install 19.3 erlang
```

Set PATH to include `/home/ubuntu/erlang/bin` in `.profile` and at the top of `.bashrc` (before it bails out on non-interactive shells.

Log out and back in.

Upload `cowboy_test-0.1.0.tar.gz`.

```
mkdir cowboy_test
(cd cowboy_test && tar xzf cowboy_test-0.1.0.tar.gz)
cowboy_test/bin/cowboy_test start
```

On a second machine, instead of installing the cowboy test program, install Tsung as explained above.
