#!/usr/bin/python

import argparse
import subprocess
import tempfile
import shutil
import os
import sys

def preserve_artifacts(builddir, destdir, uid, removeimage=False):
    logsdir = "tmp/work/qemux86-poky-linux/core-image-sato/1.0-r0/testimage"
    logsdir = os.path.join(builddir, logsdir)

    if removeimage:
        # Being lazy for glob
        image = os.path.join(logsdir, "*-testimage.*")
        subprocess.call("rm -f {}".format(image), shell=True)

    try:
        shutil.move(logsdir, destdir)
    except IOError:
        pass

    logsdir = "tmp/work/qemux86-poky-linux/core-image-sato/1.0-r0/temp"
    logsdir = os.path.join(builddir, logsdir)
    try:
        shutil.move(logsdir, destdir)
    except IOError:
        pass

    try:
        shutil.move(os.path.join(builddir, "stdout"), os.path.join(destdir, "stdout"))
    except IOError:
        pass

    subprocess.call("chown -R {} {}".format(uid, destdir), shell=True)

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
parser.add_argument("--builddir", help="Directory to build in")
parser.add_argument("--preservesuccess", action="store_true", help="Don't "
                    "remove directory if build is successful")
parser.add_argument("--removeimage", action="store_true", help="Remove image"
                    "from artifacts to save space")
parser.add_argument("--dontrenamefailures", action="store_true", help="Don't "
                    "rename directory if build is a failure")
parser.add_argument("--testsuites", default="systemd", help="Comma separated"
                    "list of test suites to run. systemd is the default.")
parser.add_argument("--imagetotest", default="core-image-sato",
                    help = "core-image-sato by default.")
parser.add_argument("--deploydir", help="Directory that contains the images "
                    "directory and the rpm directory")
parser.add_argument("--variable", action='append', help='Variable and value of'
                    ' the form "variable=value"')
parser.add_argument("--uid", default='{!s}'.format(os.getuid()), help='Numeric'
                    'uid of the owner of the artifacts.')
parser.add_argument("branch", default="master", help="Branch of poky to use")

args = parser.parse_args()

builddir = None

if not args.builddir:
    builddir = tempfile.mkdtemp(prefix="testrun-", dir="/fromhost")
else:
    builddir = args.builddir

stdoutlog = os.path.join(builddir, "stdout")
if not os.path.isdir(builddir):
    os.makedirs(builddir)

try:
    if args.fetch:
        cmd = "cd {}; git fetch --all".format(args.pokydir)
        call_with_raise(cmd, stdoutlog)

    if args.branch:
        cmd = "cd {}; git checkout {}".format(args.pokydir, args.branch)
        call_with_raise(cmd, stdoutlog)

    # Have to use bash since the default on ubuntu is dash which is garbage
    cmd = 'bash -c ". {}/oe-init-build-env {}"'.format(args.pokydir, builddir)
    call_with_raise(cmd, stdoutlog)

    shutil.copyfile("/home/yoctouser/local.conf",
                    "{}/conf/local.conf".format(builddir))

    with open("{}/conf/local.conf".format(builddir), "a") as f:
        testsuites = args.testsuites.replace(',', ' ')
        f.write("TEST_SUITES = \"{}\"\n".format(testsuites))

        if args.deploydir:
            f.write("DEPLOY_DIR = \"{}\"\n".format(args.deploydir))
            f.write("DEPLOY_DIR_IMAGE = \"{}/images\"\n".format(args.deploydir))

        if args.deploydir:
            f.write("TESTIMAGE_DUMP_DIR = \"${TEST_LOG_DIR}\"\n")

        if args.variable:
            for i in args.variable:
                var, val = i.split('=')
                f.write("{} = \"{}\"\n".format(var.strip(), val.strip()))

    # USER isn't set on ubuntu when non-interactive, so set it, otherwise
    # vncserver complains.
    os.environ['USER'] = 'yoctouser'

    cmd = 'vncserver :1'
    call_with_raise(cmd, stdoutlog)

    os.environ['DISPLAY'] = ':1'

    # If deploydir was specified we can assume that the user doesn't want to
    # build the image.
    if not args.deploydir:
        cmd = 'bash -c ". {}/oe-init-build-env {};'.format(args.pokydir, builddir) + \
              'bitbake {}"'.format(args.imagetotest)
        call_with_raise(cmd, stdoutlog)

    cmd = 'bash -c ". {}/oe-init-build-env {};'.format(args.pokydir, builddir) + \
          'bitbake {} -c testimage"'.format(args.imagetotest)
    call_with_raise(cmd, stdoutlog)
except Exception as e:
    if not args.dontrenamefailures and not args.deploydir:
        if builddir is not None:
            if args.builddir:
                print "Cowardly refusing to move failed builddir since " + \
                      "it was specified on the command line."
            else:
                shutil.move(builddir, builddir.rstrip('/') + "-failure")

    if args.deploydir:
        finaldir = tempfile.mkdtemp(prefix="testrun-", dir="/fromhost",
                                    suffix="-failure")
        preserve_artifacts(builddir, finaldir, args.uid, args.removeimage)

    raise e, None, sys.exc_info()[2]

finally:
    subprocess.call("vncserver -kill :1", shell=True)

if args.preservesuccess and args.deploydir:
    finaldir = tempfile.mkdtemp(prefix="testrun-", dir="/fromhost")
    preserve_artifacts(builddir, finaldir, args.uid, args.removeimage)

if not args.preservesuccess and not args.deploydir:
    if args.builddir:
        print "Cowardly refusing to remove successful builddir since it" + \
              "was specified on the command line."
    else:
        print "Removing {} ...".format(builddir)
        shutil.rmtree(builddir)

