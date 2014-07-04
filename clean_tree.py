#!/usr/bin/env python3
import argparse
import os
import subprocess
import string
import random


parser = argparse.ArgumentParser()

parser.add_argument("Bamfile",
        help="Path of bam file which you need to pile up")

parser.add_argument("Markerfile",
        help="Path of file which contains the target markers")

parser.add_argument("Outputfile",
        help="Path of the output file")

parser.add_argument("-r", "--Reads_thresh",
        help="The minimum number of reads for each base",
        type=int,
        default=50)

parser.add_argument("-q", "--Quality_thresh",
        help="Minimum quality for each read, integer between 10 and 39, inclusive",
        type=int,
        choices=list(range(10, 40))+[0])

parser.add_argument("-b", "--Base_majority",
        help="The minimum percentage of a base result for acceptance",
        type=int,
        choices=list(range(50,100)),
        default=95)

parser.add_argument("-n", "--nopileup",
        help="Do not pile up, use existing pileup file",
        dest="pileup",
        action='store_false')

args = parser.parse_args()

args.Base_majority = args.Base_majority / 100
assert(os.path.exists(args.Markerfile))
assert(os.path.exists(args.Bamfile))
assert(os.path.splitext(args.Bamfile)[1] == '.bam')

def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for x in range(size))

app_folder = os.path.dirname(os.path.realpath(__file__))
rsource = os.path.join(app_folder, 'clean_tree.r')
reffile = os.path.join(app_folder, 'hg19.fa')
rscriptn = '{}/tmp/main.r'.format(app_folder)
pileupfile = '{}/tmp/out.pu'.format(app_folder)
#tmp_folder = '/tmp/arwin.' + id_generator()
#os.makedirs(tmp_folder, exist_ok=True)

if args.pileup:
    pileup_cmd = "samtools.latest mpileup -f {} {} > {}".format(reffile, args.Bamfile, pileupfile)
    subprocess.call(pileup_cmd, shell=True)
    print(pileup_cmd)

roptions1 = """
Markerfile = '{Markerfile}'
Outputfile = '{Outputfile}'
Reads_thresh = {Reads_thresh}
Quality_thresh = {Quality_thresh}
Base_majority = {Base_majority}
""".format(**vars(args))
roptions2 = "Pileupfile = '{}'\n\n".format(pileupfile)

rfile = roptions1 + roptions2 + open(rsource).read()
with open(rscriptn, 'w') as r_out:
    r_out.write(rfile)
rcmd = 'Rscript --vanilla {}'.format(rscriptn)
subprocess.call(rcmd.split())
