#!/usr/bin/python

import argparse
import subprocess
import os
import tempfile
import shutil

# Raise exception if the subprocess fails
def call_with_raise(cmd, logfile):
    with open(logfile, "a") as f:
        returncode = subprocess.call(cmd, stdout=f, stderr=f, shell=True)
        if returncode != 0:
            raise Exception("ExitError: {}".format(cmd))

parser = argparse.ArgumentParser()

parser.add_argument("--pokydir", default="/home/yoctouser/poky",
                     help="Directory containing poky")
parser.add_argument("--fetch", action="store_true", help="Update poky repo")
parser.add_argument("--extraconf", action='append', help="File containing"
                    "extra configuration")
parser.add_argument("--branch", default="master", help="Branch of poky to use")
parser.add_argument("target", help="What bitbake should build")
parser.add_argument("builddir", help="Directory to build in")

args = parser.parse_args()

builddir = args.builddir

tempdir = tempfile.mkdtemp()

stdoutlog = os.path.join(builddir, "stdout")
if not os.path.isdir(builddir):
    os.makedirs(builddir)

try:
    # It is assumed if pokydir is passed in, we shouldn't touch it
    if "/home/yoctouser/poky" == args.pokydir:
        if args.fetch:
            cmd = "cd {}; git fetch --all".format(args.pokydir)
            call_with_raise(cmd, stdoutlog)
    
        if args.branch:
            cmd = "cd {}; git checkout {}".format(args.pokydir, args.branch)
            call_with_raise(cmd, stdoutlog)
    
    # Have to use bash since the default on ubuntu is dash which is garbage
    cmd = 'bash -c ". {}/oe-init-build-env {}"'.format(args.pokydir, builddir)
    call_with_raise(cmd, stdoutlog)

    local_conf = "{}/conf/local.conf".format(builddir)
    local_conf_orig = "{}/local.conf.orig".format(tempdir)
    shutil.copyfile(local_conf, local_conf_orig)

    try:
        with open(local_conf, "a") as f:
            if args.extraconf:
                for conf in args.extraconf:
                    f.write("require {}\n".format(conf))
        cmd = 'bash -c ". {}/oe-init-build-env {};'.format(args.pokydir,
               builddir)
        cmd += 'bitbake {}"'.format(args.target)
        call_with_raise(cmd, stdoutlog)

    finally:
        shutil.copyfile(local_conf_orig, local_conf)

finally:
    shutil.rmtree(tempdir, ignore_errors=True)
