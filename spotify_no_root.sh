# a: Nick Knowles (knowlen@wwu.edu)
# d: April 2017
#
# Summary: This script installs the Spotify application client onto a machine without root. 
#          -Note: while you can navigate and use all of the features of the spotify application, 
#                 you must still run the spotify web client (and redirect audio to it) in order
#                 to get sound.  
#
# Usage: $ ./spotify_no_root.sh
#    (load up spotify web player in Firefox)
#        $ spotify 
#

mkdir ~/.spotify
cd ~/.spotify

wget http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.0.53.758.gde3fc4b2-33_amd64.deb

ar -xf ./*.deb
tar -xf ./data*.tar.gz
touch ~/.bashrc_copy
touch ~/.bash_prof_copy
echo "export PATH=\$PATH:/home/$(whoami)/.spotify/usr/bin" >> ~/.bashrc_copy
echo "export PATH=\$PATH:/home/$(whoami)/.spotify/usr/bin" >> ~/.bash_prof_copy
cat ~/.bashrc >> ~/.bashrc_copy
cat ~/.bash_profile >> ~/.bash_prof_copy

mv ~/.bash_prof_copy ~/.bash_profile
mv ~/.bashrc_copy ~/.bashrc

