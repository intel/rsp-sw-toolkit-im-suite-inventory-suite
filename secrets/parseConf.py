#!/bin/python

"""This script writes the string value of JSON <confFile>'s <key> to <outFile>"""

from __future__ import print_function # handle python 2 and 3
import json
import sys

def extractValToFile(confFile, outFile, key):
    with open(confFile) as F:
        conf = json.load(F)
    if not conf[key].strip():
        del conf[key] # bit of a hack to handle py2/3 raise differences
    with open(outFile, 'w') as F:
        F.write(conf[key].strip())

if __name__ == '__main__':
    confFile, key, outFile = None, None, None
    try:
        confFile, key, outFile = (arg.strip() for arg in sys.argv[1:])
    except:
        pass # handled below

    if not all((confFile, key, outFile)):
        print("usage: {} confFile key outFile".format(sys.argv[0]))
        exit(1)

    try:
        extractValToFile(confFile, outFile, key)
        exit(0)
    except KeyError:
        print("{} is missing from {}".format(key, confFile), file=sys.stderr)
    except AttributeError:
        print("{} in {} should be a string".format(key, confFile), file=sys.stderr)
    except Exception as e:
        print("error: {}".format(e), file=sys.stderr)
    exit(1)
