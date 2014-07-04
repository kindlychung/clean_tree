#!/bin/bash

sudo apt-get install python3 r-base mawk p7zip-full wget samtools

cd ucsc_hg19/
echo

if [[ -L hg19.fa ]]; then
    echo "Link exists, deleting it..."
    rm hg19.fa
fi


if [[ ! -e hg19.fasta ]]; then
    echo "No hg19 reference data available."
    # if zip file is not there, download it, else do nothing
    if [[ ! -e hg19.zip ]]; then
        echo "Downloading hg19 reference data..."
        wget http://updates.iontorrent.com/reference/hg19.zip
    else
        echo "Extracting from existing archive"
    fi
    # extract zip file
    7z x hg19.zip
    rm hg19.zip
else
    echo "hg19 reference data available, cool!"
fi

cd ..

echo "Linking to executables..."
sudo ln -s clean_tree.py clean_tree_printout.sh /usr/local/bin/ &&  echo "Done!"
