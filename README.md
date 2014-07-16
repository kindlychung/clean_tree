# Requirements
* Operating system: Linux only. Tested on Ubuntu 12.04LTS, but should also work on newer versions of Ubuntu. Can be easily ported to other Linux distributions.
* R, python3, wget, git. All these are taken care of with the `install.sh` script if you are on Ubuntu Linux.
* Internet connection during installation (for downloading hg19 reference data).

# Download source from github:

* Open a terminal.
* Change to the directory where you want to put this software, for example cd `/home/user/opt/`, can be anything you like.
* `git clone https://github.com/kindlychung/clean_tree.git`
* Get into the directory you just downloaded: `cd clean_tree`

# Installation

1. Install dependencies, you can skip this step if these packages are already installed on your system

    `sudo apt-get install git-core apt-get install python3 r-base mawk p7zip-full wget samtools`

2. Link to executables and download hg19 data, configurations

    `./install.py`

3. To make the configurations effective immediately:

    `source ~/.profile`

4. Install required R packages

    `./install.r`

In step 2 above, `install.py` put all executables in `~/bin` by default,
making them only available to the user, in case you want install it system
wide, you can do something like this instead:

    ./install.py --prefix /usr/local/bin

# Usage and examples

See this [blog post](http://mathiology.blogspot.nl/2014/07/cleantree-software-for-high-resolution.html).

# Bug report

Please email me at kindlychung _A*T_ gmail.com when there is a problem getting the software up and running.

