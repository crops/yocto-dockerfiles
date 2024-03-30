#!/bin/bash

# build-install-dumb-init.sh
#
# Copyright (C) 2017-2021 Intel Corporation
#
# SPDX-License-Identifier: GPL-2.0-only
#

set -x

builddir=`mktemp -d` || exit 1
cd $builddir || exit 1

if grep -q Alma /etc/*release; then
    INSTALL_CMD="dnf -y install glibc-static"
    REMOVE_CMD="dnf -y remove glibc-static"
elif grep -q CentOS /etc/*release; then
    INSTALL_CMD="yum -y install glibc-static"
    REMOVE_CMD="yum -y remove glibc-static"
elif grep -q Fedora /etc/*release; then
    INSTALL_CMD="dnf -y install glibc-static"
    REMOVE_CMD="dnf -y remove glibc-static"
elif grep -q Ubuntu /etc/*release || grep -q Debian /etc/*release; then
    INSTALL_CMD=""
    REMOVE_CMD=""
elif grep -q openSUSE /etc/*release; then
    INSTALL_CMD="zypper --non-interactive install glibc-devel-static"
    REMOVE_CMD="zypper --non-interactive remove glibc-devel-static"
else
    exit 1
fi

wget https://github.com/Yelp/dumb-init/archive/v1.2.5.tar.gz || exit 1
echo "3eda470d8a4a89123f4516d26877a727c0945006c8830b7e3bad717a5f6efc4e  v1.2.5.tar.gz" > sha256sums || exit 1

sha256sum -c sha256sums || exit 1
tar xf v1.2.5.tar.gz || exit 1
# https://github.com/Yelp/dumb-init/issues/273
sed -i '128 i \ \ \ \ packages=[],' dumb-init*/setup.py || exit 1
# https://github.com/Yelp/dumb-init/issues/286
echo py >> dumb-init*/requirements-dev.txt

# Replace the versions of python used for testing dumb-init. Since it is
# testing c code, and not python it shouldn't matter. Also remove the
# pre-commit test from the test rule because we don't care.
sed -i -e 's/envlist = .*/envlist = py3/' dumb-init*/tox.ini || exit 1
sed -i -e 's/tox -e pre-commit//' dumb-init*/Makefile || exit 1

$INSTALL_CMD || exit 1

virtualenv $builddir/venv || exit 1
. $builddir/venv/bin/activate || exit 1
pip3 install setuptools tox || exit 1

. $builddir/venv/bin/activate || exit 1
cd dumb-init* || exit 1
make dumb-init || exit 1
make test || exit 1

cp dumb-init /usr/bin/dumb-init || exit 1
chmod +x /usr/bin/dumb-init || exit 1

rm $builddir -rf || exit 1
# Really this should be an exit 1 as well if it fails, but for some reason
# on travis, for fedora it consistently says that it cannot acquire the
# the transaction lock.
$REMOVE_CMD || exit 0
