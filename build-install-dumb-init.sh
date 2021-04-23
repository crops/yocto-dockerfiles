#!/bin/bash

builddir=`mktemp -d` || exit 1
cd $builddir || exit 1

if grep -q CentOS /etc/*release; then
    INSTALL_CMD="yum -y install glibc-static"
    REMOVE_CMD="yum -y remove glibc-static"
elif grep -q Fedora /etc/*release; then
    INSTALL_CMD="dnf -y install glibc-static"
    REMOVE_CMD="dnf -y remove glibc-static"
elif grep -q Ubuntu /etc/*release || grep -q Debian /etc/*release; then
    INSTALL_CMD="apt-get install -y python3-pip"
    REMOVE_CMD="apt-get remove -y python3-pip"
elif grep -q openSUSE /etc/*release; then
    INSTALL_CMD="zypper --non-interactive install python3-pip glibc-devel-static"
    REMOVE_CMD="zypper --non-interactive remove python3-pip glibc-devel-static"
else
    exit 1
fi

wget https://github.com/Yelp/dumb-init/archive/v1.2.0.tar.gz || exit 1
echo "74486997321bd939cad2ee6af030f481d39751bc9aa0ece84ed55f864e309a3f  v1.2.0.tar.gz" > sha256sums || exit 1

wget https://github.com/Yelp/dumb-init/commit/0708f2779cbcd10e08c6e4cb6551ccea93d75f09.patch || exit 1
echo "eeabd5b66cd2fae2d2edb38f47b3325c56138521f1ea3381042ab156b17785cc  0708f2779cbcd10e08c6e4cb6551ccea93d75f09.patch" >> sha256sums || exit 1

sha256sum -c sha256sums || exit 1
tar xf v1.2.0.tar.gz || exit 1

# patch to increase sleep in a test that can fail on slower systems
patch -d dumb-init-1.2.0 -p1 < 0708f2779cbcd10e08c6e4cb6551ccea93d75f09.patch

# Replace the versions of python used for testing dumb-init. Since it is
# testing c code, and not python it shouldn't matter. Also remove the
# pre-commit test from the test rule because we don't care.
sed -i -e 's/envlist = .*/envlist = py3/' dumb-init*/tox.ini || exit 1
sed -i -e 's/tox -e pre-commit//' dumb-init*/Makefile || exit 1

$INSTALL_CMD || exit 1

# Setup the buildtools enviroment in the subshell, since we really only want
# to use python3 from buildtools.
(
if [ -e /opt/poky/*/environment-setup-*-pokysdk-linux ]; then
    . /opt/poky/*/environment-setup-*-pokysdk-linux
fi

pip3 install virtualenv || exit 1

virtualenv $builddir/venv || exit 1
. $builddir/venv/bin/activate || exit 1
pip3 install tox || exit 1
)

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
