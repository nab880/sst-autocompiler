#!/bin/bash
set -x

cat test_tls.cc

hg++ \
    -D_LIBCPP_REMOVE_TRANSITIVE_INCLUDES \
    -I$HOME/sst-macro/install/include/sumi-mpi \
    -c test_tls.cc
hg++ test_tls.o -o mylib.so

cat params.ini

sstmac -f params.ini
