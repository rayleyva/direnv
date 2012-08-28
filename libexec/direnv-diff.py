#!/usr/bin/python
#
# Tools to backup the current environment

from os import environ
from zlib import decompress
from base64 import urlsafe_b64decode
from pipes import quote
from optparse import OptionParser

IGNORED_KEYS = set([
        '_',
        'PWD',
        'OLDPWD',
        'SHLVL',
        'SHELL',
        'DIRENV_BACKUP',
        'DIRENV_LIBEXEC',
])

def restore_env(serialized_env):
    return eval(
            decompress(
                urlsafe_b64decode(serialized_env)))

def diff_env(env1, env2):
    new_env = {}
    for k in set(env1.keys()).union(env2.keys()):
        if not k in IGNORED_KEYS:
            if env1.get(k) != env2.get(k):
                if k in env2:
                    new_env[k] = env2[k]
                else:
                    new_env[k] = None
    return new_env

def to_shell(env_diff):
    str = ""
    for k, v in env_diff.items():
        if v:
            str += "export %s=%s;" % (k, quote(v))
        else:
            if k == "PS1":
                pass
                # unsetting PS1 doesn't restore the default in OSX's bash
            else:
                str += "unset %s;" % (k, )
    return str

parser = OptionParser(usage="usage: %prog [options] [OLD_ENV]")
parser.add_option('-r', '--reverse', dest='reverse', action="store_true", help='Uses the OLD_ENV as the source')

(options, args) = parser.parse_args()

if len(args) > 0:
    old_env = args[0]
else:
    old_env = environ['DIRENV_BACKUP']

old_env = restore_env(old_env)

if options.reverse:
  diff = diff_env(old_env, environ)
else:
  diff = diff_env(environ, old_env)

print to_shell(diff)
