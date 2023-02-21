#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Setup XDG directories in a way to unclutter home directory.
#
# This script moves directories from the old location, as defined in the
# current user-dirs.dir file, to the new location.
#
# Copyright (c) 2009 Örjan Persson (o@42mm.org)

import re
import os
import shutil
import sys


def main():
    sysname, nodename, release, version, machine = os.uname()
    print('Setting up dotfiles for %s on %s %s %s..' % \
        (nodename, sysname, release, machine))

    dotfiles = os.path.dirname(__file__)
    if not os.path.exists(dotfiles):
    	raise Exception('Failed to determine dotfiles path')

    def parse_xdg_dirs(path):
        """Parse the user-dirs.dirs file"""
        xdg_re = re.compile(r'^XDG_([^_]+)_DIR=(.*)$')
        items = {}
        with open(path) as f:
            for line in f.readlines():
                m = xdg_re.match(line)
                if m is not None:
                    # remove any quotation
                    val = m.group(2).strip('"')
                    # make sure to replace $HOME with shell variables
                    items[m.group(1)] = os.path.expandvars(val)
        return items

    # setup xdg paths by renaming directories already created (should be)
    try:
        source = os.path.join(dotfiles, 'user-dirs.dirs')
        target = os.path.expanduser('~/.config/user-dirs.dirs')

        new_xdg_dirs = parse_xdg_dirs(source)
        old_xdg_dirs = parse_xdg_dirs(target)
        for key in old_xdg_dirs:
            if key not in new_xdg_dirs:
                raise NotImplementedError('Unhandled xdg key: %s' % (key,))
        for key, new_path in new_xdg_dirs.items():
            old_path = old_xdg_dirs.get(key)
            if old_path != new_path or not os.path.exists(new_path):
                if not os.path.exists(new_path):
                    if old_path is None or not os.path.exists(old_path):
                        print('making', new_path)
                        os.makedirs(new_path)
                    elif old_path.strip('/') != os.path.expanduser('~'):
                        print('renaming', old_path, new_path)
                        os.renames(old_path, new_path)
                    else:
                        print('ignoring', old_path, new_path)
                else:
                    if os.path.exists(old_path):
                        raise NotImplementedError('Both new and old xdg dir exists (old: %s, new: %s)' % (old_path, new_path))
        shutil.copyfile(source, target)
    except (IOError, OSError) as exc:
        print('Failed to setup xdg dirs:', str(exc))

    return 0

if __name__ == '__main__':
    sys.exit(main())
