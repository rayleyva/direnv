#!/usr/bin/python
#
# Tools to backup the current environment

from os import environ
from zlib import compress
from base64 import urlsafe_b64encode

IGNORED_KEYS = set([
        '_',
        'PWD',
        'OLDPWD',
        'SHLVL',
        'SHELL',
        'DIRENV_BACKUP',
        'DIRENV_LIBEXEC',
])

env = environ.copy()

# Don't backup unused variables
for key in IGNORED_KEYS.intersection(env.keys()):
    del env[key]

env = compress(str(env))

env = urlsafe_b64encode(env)

print env
