#!/usr/bin/python3

import argparse
import os
import sys
import errno

def force_symlink(file1, file2):
    try:
        os.symlink(file1, file2)
    except OSError as e:
        if e.errno == errno.EEXIST:
            os.remove(file2)
            os.symlink(file1, file2)

homedir = os.getenv("HOME")
homebin = os.path.join(homedir, "bin")
parser = argparse.ArgumentParser(description="Install clean_tree")
parser.add_argument("--prefix", default=homebin, help="Folder to put executables in")
args = parser.parse_args()

# get hg19 data
if os.path.isdir("ucsc_hg19"):
    print("It looks ucsc_hg19 data exists, \
I assume this is because you have installed \
this software before, before, and I will leave it alone. \
In case of doubt, delete it and run install.py again.")
else:
    if os.path.isfile("ucsc_hg19.7z"):
        print("Extracting from existing archive...")
    else:
        print("Downloading hg19 reference data...")
        os.system("wget -O ucsc_hg19.7z \
https://www.dropbox.com/s/mwu555svl3tisvy/ucsc_hg19.7z")

    # extract zip file
    os.system("7z x ucsc_hg19.7z")
    os.system("rm ucsc_hg19.7z")


# make sure prefix dir is there
if not os.path.exists(args.prefix):
    try:
        os.mkdir(args.prefix)
    except:
        sys.stderr.write("Failed to create directory {0}! \n".format(args.prefix))

# get current location of scripts
app_folder = os.path.dirname(os.path.realpath(__file__))
print("clean_tree executables are in {0}".format(app_folder))

# link to executables
print("Linking to executables...")
clean_tree_py = os.path.join(app_folder, "clean_tree.py")
clean_tree_py_link = os.path.join(args.prefix, "clean_tree.py")
clean_tree_pr = os.path.join(app_folder, "clean_tree_printout.sh")
clean_tree_pr_link = os.path.join(args.prefix, "clean_tree_printout.sh")
force_symlink(clean_tree_py, clean_tree_py_link)
force_symlink(clean_tree_pr, clean_tree_pr_link)

# make sure prefix dir is in PATH
paths = os.getenv("PATH").split(":")
if not args.prefix in paths:
    bashprofile = os.path.join(homedir + ".profile")
    with open(bashprofile, "a") as profilefh:
        profilefh.write("""PATH="{0}:$PATH" """.format(args.prefix))
