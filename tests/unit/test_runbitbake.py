#!/usr/bin/env python

import unittest
import os
import subprocess
import shutil
import tempfile
import sys
import stat
import imp


class RunBitbakeTestBase(unittest.TestCase):
    def setUp(self):
        self.tempdir = tempfile.mkdtemp(prefix="runbitbaketest-tmpdir")

        self.pokydir = os.path.join(self.tempdir, "poky")
        os.mkdir(self.pokydir)

        # runbitbake.py requires --pokydir with a "oe-init-build-env" script
        self.setupscript = os.path.join(self.pokydir, "oe-init-build-env")
        with open(self.setupscript, "w"):
            pass

        # Create a builddir and confdir as if oe-init-build-env had ran
        self.builddir = os.path.join(self.tempdir, "build")
        self.confdir = os.path.join(self.builddir, "conf")
        os.mkdir(self.builddir)
        os.mkdir(self.confdir)

        # Create an executable bitbake that does nothing
        self.bindir = os.path.join(self.tempdir, "bin")
        os.mkdir(self.bindir)

        self.bitbake = os.path.join(self.bindir, "bitbake")
        with open(self.bitbake, "w") as f:
            f.write("#!/bin/sh\n")
            os.chmod(self.bitbake, stat.S_IRWXU)

        # Make sure runbitbake.py can run our fake bitbake
        os.environ["PATH"] = "{}:{}".format(self.bindir, os.environ["PATH"])

        # We will have one line local.conf and bblayers.conf.
        self.local_conf = os.path.join(self.confdir, "local.conf")
        with open(self.local_conf, "w") as f:
            f.write("Some data\n")

        self.bblayers_conf = os.path.join(self.confdir, "bblayers.conf")
        with open(self.bblayers_conf, "w") as f:
            f.write("Other data\n")

        # Create the files that contain extra data to be added to the original
        # configuration files
        self.extraconf = os.path.join(self.tempdir, "extra.conf")
        with open(self.extraconf, "w") as f:
            f.write("MOAR STUFF\nEVEN MOAR!!!!\n")

        self.extralayers = os.path.join(self.tempdir, "bblayers_extra.conf")
        with open(self.extralayers, "w") as f:
            f.write("BBLAYERS MOAR STUFF\nEVEN MOAR BBLAYERS!!!!\n")

    def tearDown(self):
        shutil.rmtree(self.tempdir, ignore_errors=True)


class ConfFilesTest(RunBitbakeTestBase):
    def setUp(self):
        super(ConfFilesTest, self).setUp()

        # These ".orig" files are for checking that the file is restored back
        # to the original state
        self.local_conf_orig = os.path.join(self.tempdir, "local.conf.orig")
        self.bblayers_conf_orig = os.path.join(self.tempdir,
                                               "bblayers.conf.orig")
        shutil.copyfile(self.local_conf, self.local_conf_orig)
        shutil.copyfile(self.bblayers_conf, self.bblayers_conf_orig)

    def test_files_are_restored(self):
        cmd = """python helpers/runbitbake.py --pokydir={} """ \
              """-t junk -b {} """ \
              """--extraconf={} """ \
              """--extralayers={}""".format(self.pokydir, self.builddir,
                                            self.extraconf, self.extralayers)

        subprocess.call(cmd.split(), stderr=sys.stderr, stdout=sys.stdout,
                        shell=False)

        with open(self.local_conf_orig, "r") as f:
            origlines = f.readlines()
        with open(self.local_conf, "r") as f:
            newlines = f.readlines()
        self.assertListEqual(origlines, newlines)

        with open(self.bblayers_conf_orig, "r") as f:
            origlines = f.readlines()
        with open(self.bblayers_conf, "r") as f:
            newlines = f.readlines()
        self.assertListEqual(origlines, newlines)


class AddExtraTest(RunBitbakeTestBase):
    def setUp(self):
        super(AddExtraTest, self).setUp()
        # Since we are importing a file in the source directory, this prevents
        # cluttering the directory with a .pyc file.
        sys.dont_write_bytecode = True

        self.runbitbake = os.path.join("helpers", "runbitbake.py")
        self.module = imp.load_source("", self.runbitbake)

        self.addextra_tempdir = os.path.join(self.tempdir, "addextratmp")
        os.mkdir(self.addextra_tempdir)

    def test_addextra_changed_files(self):
        addextra = self.module.addextra
        addextra(self.addextra_tempdir, self.builddir, "local.conf",
                 [self.extraconf])

        with open(self.extraconf, "r") as f:
            extraconflines = set(f.readlines())
        with open(self.local_conf, "r") as f:
            localconflines = set(f.readlines())

        intersection = extraconflines & localconflines
        self.assertListEqual(list(intersection), list(extraconflines))

if __name__ == '__main__':
    unittest.main()
