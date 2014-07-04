<h3>Requirements</h3>
<ul>
<li>Operating system: Linux only. Tested on Ubuntu 12.04LTS, but should also work on newer versions of Ubuntu. Can be easily ported to other Linux distributions.</li>
<li>R, python3, wget, git. All these are taken care of with the install.sh script if you are on Ubuntu Linux.</li>
<li>Internet connection during installation (for downloading hg19 reference data).</li>
</ul>

<h3>Download source from github:</h3>
<ul>
<li>Open a terminal.</li>
<li>Change to the directory where you want to put this software, for example <code>cd /home/user/opt/</code>, can be anything you like.</li>
<li> <code>sudo apt-get install git-core</code></li>
<li>git clone https://github.com/kindlychung/clean_tree.git</li>
<li> Get into the directory you just downloaded: <code>cd clean_tree</code></li>
</ul>

<h3>Installation</h3>
<pre>
# install dependencies and get hg19 data
./install.sh
# install required R packages
./install.r
</pre>

