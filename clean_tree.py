#!/usr/bin/env python3
import argparse
import os
import subprocess


parser = argparse.ArgumentParser()

parser.add_argument("Bamfile", help="Path of bam file which you need to pile up")
parser.add_argument("Markerfile", help="Path of file which contains the target markers")
parser.add_argument("Outputfile", help="Path of the output file")
parser.add_argument("-r", "--Reads_thresh", help="The minimum number of reads for each base", type=int, default=50)
parser.add_argument("-q", "--Quality_thresh", help="Minimum quality for each read, integer between 10 and 39, inclusive", type=int, choices=list(range(10, 40))+[0])
parser.add_argument("-b", "--Base_majority", help="The minimum percentage of a base result for acceptance", type=int, choices=list(range(50,100)), default=95)
args = parser.parse_args()

args.Base_majority = args.Base_majority / 100
assert(os.path.exists(args.Markerfile))
assert(os.path.exists(args.Bamfile))
assert(os.path.splitext(args.Bamfile)[1] == '.bam')

pileup_cmd = "samtools.latest mpileup -f hg19.fa {} > tmp/out.pu".format(args.Bamfile)
subprocess.call(pileup_cmd, shell=True)
print(pileup_cmd)

roptions = """
Markerfile = '{Markerfile}'
Outputfile = '{Outputfile}'
Reads_thresh = {Reads_thresh}
Quality_thresh = {Quality_thresh}
Base_majority = {Base_majority}


""".format(**vars(args))

rscriptn = 'tmp/main.r'
rfile = roptions + open('clean_tree.r').read()
with open(rscriptn, 'w') as r_out:
    r_out.write(rfile)
subprocess.call('Rscript --vanilla tmp/main.r'.split())


print(rfile)
