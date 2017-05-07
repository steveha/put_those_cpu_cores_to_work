#!/usr/bin/env python

import argparse
import os
import subprocess as sp
import sys
import tempfile

from contextlib import contextmanager


DESCRIPTION="Sync FLAC files from one dir to MP3 files in another"

arg_parser = argparse.ArgumentParser(description=DESCRIPTION)
arg_parser.add_argument("-v", "--verbose", action="store_true",
        help="write verbose output (helps with debugging)")
arg_parser.add_argument("source_dir", nargs='?', type=str, default=None,
        help="directory containing all FLAC audio files")
arg_parser.add_argument("dest_dir", nargs='?', type=str, default=None,
        help="directory into which all MP3 files will go")
arg_parser.add_argument("relative_dir", nargs='?', type=str, default=None,
        help="subdirectory of source_dir to sync to dest_dir")

if len(sys.argv) < 2:
    sys.argv.append("--help")

args = arg_parser.parse_args()


class temp_fname(object):
    def __init__(self, suffix='', prefix='tmp', dir=None):
        # Create a temp file.
        fd, name = tempfile.mkstemp(suffix=suffix, prefix=prefix, dir=dir)
        # Close it... now it exists as a zero-length file, free to be overwritten.
        # There is no danger of a temp name collision as it does still exist.
        os.close(fd)
        self.name = name

    def __enter__(self):
        return self.name

    def __exit__(self, exc_type, exc_value, traceback):
        # No matter how the "with" block is exited, we clean up the temp file here.
        if os.path.exists(self.name):
            os.remove(self.name)
        # Don't swallow any exceptions, let them raise.
        return False 

def run_cmd(cmd):
    """
    Run a command, collecting output.  If the command succeeds, output is
    discarded.  If command fails, raise an exception that has the output
    attached.  This way the program can print the output.

    stdout and stderr are collected together and returned together.
    """
    try:
        sp.check_output(cmd, stderr=sp.STDOUT)
    except (KeyboardInterrupt, sp.CalledProcessError) as e:
        if isinstance(e, KeyboardInterrupt):
            # We will raise a fake CalledProcessError just to make it more convenient to catch exceptions from this.
            e = sp.CalledProcessError(cmd=cmd, returncode=255, output="Terminated by keyboard interrupt")
            sys.stderr.write('\n')

        raise e

def list_dir_files(path, extension):
    return sorted(f for f in os.listdir(path) if f.endswith(extension))



SRC_DIR = os.path.realpath(os.path.join(args.source_dir, args.relative_dir))
DEST_DIR = os.path.realpath(os.path.join(args.dest_dir, args.relative_dir))

if args.verbose:
    print("Source dir: " + SRC_DIR)
    print("Dest dir: " + DEST_DIR)

if not os.path.exists(DEST_DIR):
    os.makedirs(DEST_DIR)

files = list_dir_files(SRC_DIR, ".flac")
if not files:
    sys.stderr.write('Source directory "{}" contains no FLAC files.\n'.format(SRC_DIR))
    sys.exit(2)

try:
    for fname_flac in files:
        fname_mp3 = fname_flac.replace(".flac", '') + ".mp3"
        src = os.path.join(SRC_DIR, fname_flac)
        dest = os.path.join(DEST_DIR, fname_mp3)
        with temp_fname(prefix="mp3_sync", suffix=".wav") as temp:
            if os.path.exists(dest):
                if args.verbose:
                    print("skipping: " + dest)
                continue
            if args.verbose:
                #print("{} --> {} ({})".format(src, dest, temp))
                print(dest)
            run_cmd(["flac", "-d", "-f", "--totally-silent", src, "-o", temp])
            run_cmd(["lame", "-Shv", temp, dest])
except sp.CalledProcessError as e:
    if os.path.exists(dest):
        if args.verbose:
            print("cleaning up: " + dest)
        os.remove(dest)

    sys.stderr.write(e.output + '\n')
    sys.exit(e.returncode)
