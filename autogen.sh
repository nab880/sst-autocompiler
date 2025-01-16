#!/bin/bash

aclocal -I config
autoconf
automake --foreign --add-missing --include-deps
autoreconf --force --install
