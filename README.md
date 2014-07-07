# Requirements
* Operating system: Linux only. Tested on Ubuntu 12.04LTS, but should also work on newer versions of Ubuntu. Can be easily ported to other Linux distributions.
* R, python3, wget, git. All these are taken care of with the `install.sh` script if you are on Ubuntu Linux.
* Internet connection during installation (for downloading hg19 reference data).

# Download source from github:

* Open a terminal.
* Change to the directory where you want to put this software, for example cd `/home/user/opt/`, can be anything you like.
* `sudo apt-get install git-core`
* `git clone https://github.com/kindlychung/clean_tree.git`
* Get into the directory you just downloaded: `cd clean_tree`

# Installation

    # install dependencies
    ./install.sh
    # link to executables and download hg19 data, configurations
    ./install.py
    # to make the configurations effective immediately:
    source ~/.profile
    # install required R packages
    ./install.r

# Usage and examples

See this [blog post](http://mathiology.blogspot.nl/2014/07/cleantree-software-for-high-resolution.html).

# Bug report

Please email me at kindlychung _A*T_ gmail.com when there is a problem getting the software up and running.

