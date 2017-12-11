# a: Nick Knowles (knowlen@wwu.edu, knowlen.github.io)
# d: April 2017 (updated Dec 2017)
#
# Summary: This script installs the Spotify application client onto a machine without root. 
#
# Install: $ ./spotify_no_root.sh
# Usage:   $ spotify 
#

rm -rf ~/.spotify
mkdir ~/.spotify
cd ~/.spotify
# Last Updated: 21-Nov-2017
wget http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.0.67.582.g19436fa3-28_amd64.deb
fakeroot sh -c '
dpkg-deb -R ./*.deb ./
'
newpath="export PATH=\$PATH:/home/$(whoami)/.spotify/usr/bin" 

# Add executable to the path
if ! grep -q "$newpath" ~/.bashrc; then
    echo "$newpath" >> ~/.bashrc;
fi

if ! grep -q "$newpath" ~/.bash_profile; then
    echo "$newpath" >> ~/.bash_profile;
fi

