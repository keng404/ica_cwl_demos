#!/usr/bin/python3
import argparse
import sys, getopt
import shlex, subprocess
import os

def name_log_func(argv):
    if ('bwa' in argv):
        name_log = os.path.basename(argv[-1]).split('.')[0]+ '.bwa.log'
    return name_log 

def full_run(argv):
    os.system(argv)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--threads', default = '16',type = str, help="number of threads")
    parser.add_argument('--read_group_header',type = str, help="read group header of SAM file")
    parser.add_argument('--output_sam',type = str, help="output SAM file")
    parser.add_argument('--additional_params',type = str, help="output SAM file")
    args, extras = parser.parse_known_args()
    full_bwa_cmd = ["/usr/local/bin/bwa mem"]
    if args.threads is not None:
        to_add = ["-t",args.threads]
        full_bwa_cmd = full_bwa_cmd + to_add
    if args.read_group_header is not None:
        to_add = ["-R","'" + args.read_group_header + "'"]
        full_bwa_cmd = full_bwa_cmd + to_add
    if args.additional_params is not None:
        to_add = [additional_params]
        full_bwa_cmd = full_bwa_cmd + to_add        
    if len(extras) > 0:
        full_bwa_cmd = full_bwa_cmd + extras
    if args.output_sam is not None:
        to_add = [">",args.output_sam]
        full_bwa_cmd = full_bwa_cmd + to_add
    full_bwa_cmd_str = " ".join(full_bwa_cmd)
    full_bwa_cmd = shlex.split(full_bwa_cmd_str,posix=False)
    print("Running:\t" +full_bwa_cmd_str)
    full_run(full_bwa_cmd_str)


