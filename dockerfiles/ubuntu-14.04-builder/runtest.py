#!/usr/bin/python

import argparse
import subprocess
import tempfile
import shutil
import os
import sys

scriptdir = os.path.dirname(os.path.realpath(__file__))

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
        shutil.move(os.path.join(builddir, "test-stdout"), os.path.join(destdir, "test-stdout"))
    except IOError:
        pass

    subprocess.call("chown -R {} {}".format(uid, destdir), shell=True)
    subprocess.call("rm -rf {}".format(builddir), shell=True)

# Raise exception if the subprocess fails
def call_with_raise(cmd, logfile):
    with open(logfile, "a") as f:
        returncode = subprocess.call(cmd, stdout=f, stderr=f, shell=True)
        if returncode != 0:
            raise Exception("ExitError: {}".format(cmd))

parser = argparse.ArgumentParser()

parser.add_argument("--pokydir", default="/home/yoctouser/poky",
                     help="Directory containing poky")
parser.add_argument("--extraconf", action='append', help="File containing"
                    "extra configuration")
parser.add_argument("--builddir", help="Directory to build in")
parser.add_argument("--preservesuccess", action="store_true", help="Don't "
                    "remove directory if build is successful")
parser.add_argument("--removeimage", action="store_true", help="Remove image"
                    "from artifacts to save space")
parser.add_argument("--dontrenamefailures", action="store_true", help="Don't "
                    "rename directory if build is a failure")
parser.add_argument("--imagetotest", default="core-image-sato",
                    help = "core-image-sato by default.")
parser.add_argument("deploydir", help="Directory that contains the images "
                    "directory and the rpm directory")
parser.add_argument("testsuites", default="systemd", help="Comma separated"
                    "list of test suites to run.")
# uid is a remnant from before the container set up the permissions properly
# remove it later
parser.add_argument("--uid", default='{!s}'.format(os.getuid()), help='Numeric'
                    'uid of the owner of the artifacts.')
parser.add_argument("--outputprefix", default='testrun-')

args = parser.parse_args()

builddir = None

if not args.builddir:
    builddir = tempfile.mkdtemp(prefix=args.outputprefix, dir="/fromhost")
else:
    builddir = args.builddir

stdoutlog = os.path.join(builddir, "test-stdout")
if not os.path.isdir(builddir):
    os.makedirs(builddir)

try:
    extraconf = "{}/conf/testconf.inc".format(builddir)
    cmd = "mkdir -p {}/conf".format(builddir)
    call_with_raise(cmd, stdoutlog)

    with open(extraconf, "w") as f:
        testsuites = args.testsuites.replace(',', ' ')
        f.write("TEST_SUITES = \"{}\"\n".format(testsuites))

        if args.deploydir:
            f.write("DEPLOY_DIR = \"{}\"\n".format(args.deploydir))
            f.write("DEPLOY_DIR_IMAGE = \"{}/images\"\n".format(args.deploydir))

        f.write("TESTIMAGE_DUMP_DIR = \"${TEST_LOG_DIR}\"\n")

        f.write("INHERIT += \"testimage\"\n")
        f.write("CONNECTIVITY_CHECK_URIS = \"\"\n")

    # USER isn't set on ubuntu when non-interactive, so set it, otherwise
    # vncserver complains.
    os.environ['USER'] = 'yoctouser'

    cmd = 'vncserver :1'
    call_with_raise(cmd, stdoutlog)

    os.environ['DISPLAY'] = ':1'

    bbtarget = "\"{} -c testimage\"".format(args.imagetotest)
    runbitbake = "{}/runbitbake.py".format(scriptdir)
    allextraconf = " ".join(["--extraconf={}".format(x) for x in args.extraconf])

    cmd = "{} --pokydir={} --extraconf={} {} {} {}".format(runbitbake, args.pokydir,
                                   extraconf, allextraconf,
                                   bbtarget, builddir)
    call_with_raise(cmd, stdoutlog)

except Exception as e:
    finaldir = tempfile.mkdtemp(prefix=args.outputprefix, dir="/fromhost",
                                suffix="-failure")
    preserve_artifacts(builddir, finaldir, args.uid, args.removeimage)

    raise e, None, sys.exc_info()[2]

finally:
    subprocess.call("vncserver -kill :1", shell=True)

if args.preservesuccess:
    finaldir = tempfile.mkdtemp(prefix=args.outputprefix, dir="/fromhost")
    preserve_artifacts(builddir, finaldir, args.uid, args.removeimage)
