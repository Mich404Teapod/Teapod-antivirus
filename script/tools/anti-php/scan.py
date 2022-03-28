import fnmatch
import hashlib
import os
import sys

try:
    import yara
except ImportError:
    print('Please install python-yara')
    sys.exit(1)

if len(sys.argv) != 3:
    print('Usage: %s name_of_the_rule_and_version folder_to_scan' % sys.argv[0])
    sys.exit(1)

if not os.path.isdir(sys.argv[2]):
    print('%s is not a folder !' % sys.argv[2])
    sys.exit(1)

try:
    rules = yara.compile(sys.path[0]+'/../php.yar', includes=True, error_on_warning=False)
except yara.SyntaxError as e:
    print("Can't compile rules: %s" % e)
    sys.exit(1)

output_list = list()

for curdir, dirnames, filenames in os.walk(sys.argv[2]):
    for filename in filenames:
        fname = os.path.join(curdir, filename)
        if 0 < os.stat(fname).st_size < 5 * 1024 * 1024:
            matches = rules.match(fname, fast=True)
            if matches:
                with open(fname, 'rb') as f:
                    digest = hashlib.sha1(f.read()).hexdigest()
                output_list.append('hash.sha1(0, filesize) == "%s" or // %s' % (digest, fname))


if output_list:
    output_rule = 'import "hash"\n\nrule %s\n{\n\tcondition:\n\t\t/* %s */\n\t\t' % (sys.argv[1].split(' ')[0], sys.argv[1])
    output_rule += '\n\t\t'.join(output_list)
    output_rule += '\n\t\tfalse\n}'
    print(output_rule)
