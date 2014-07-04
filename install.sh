#!/bin/bash

sudo apt-get install python3 r-base mawk p7zip-full wget samtools

appdir=$(pwd)
echo clean_tree executables are in: $pwd
cd ucsc_hg19/
echo

if [[ -L hg19.fa ]]; then
    echo "Link exists, deleting it..."
    rm hg19.fa
fi


if [[ ! -e hg19.fa ]]; then
    echo "No hg19 reference data available."
    # if zip file is not there, download it, else do nothing
    if [[ ! -e hg19.zip ]]; then
        echo "Downloading hg19 reference data..."
        wget -O ucsc_hg19.7z https://dc2.safesync.com/FhVdMSC/ucsc_hg19.7z?a=FF0wW9k589U
    else
        echo "Extracting from existing archive"
    fi
    # extract zip file
    7z x ucsc_hg19.7z
    rm ucsc_hg19.7z
    mv ucsc_hg19/hg19.fa .
    rm -rf ucsc_hg19
else
    echo "hg19 reference data available, cool!"
fi

cd /usr/local/bin/

echo "Linking to executables..."
sudo ln -s "$appdir/clean_tree.py" "$appdir/clean_tree_printout.sh" /usr/local/bin/ &&  echo "Done!"
