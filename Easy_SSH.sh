# Author: Nick Knowles (knowlen@wwu.edu, github.com/knowlen)
# Date: Winter 2017
# 
# A general SSH script I use to make getting
# from node A to node B on the WWU CS dept 
# network a little quicker.
#
#

if [ "$1" == "-h" ]; then
    echo "Easy SSH (h)  A quick SSH interface to use within the Computer Science 
              department at Western Washington University 
    "
    echo "Usage: ./Easy_SSH.sh"
    echo "Usage (first time from personal computer): ./Easy_SSH.sh 'CS username'"
    echo "NOTE: The script remembers username after first use."
    echo " 
   OPTIONS:
   install  Adds the program to your path as 'easy_ssh' so it can be called
            easily from wherever. 
            Usage/Example: $./Easy_SSH install
                           $ easy_ssh

  "
    exit
fi

echo -n "room #: "
read x
echo -n "pc #: "
read y

# hutch_research student
if [ "$x" == "408" ]; then
    x="cf408-hut"
fi

NODE="$(uname -n)"

# if on a research machine
if [[ $NODE == "cf408-"* ]]; then
 PWD=$(pwd)
 ssh -t -p922 $(whoami)@linux.cs.wwu.edu ssh -p922 $(whoami)@cf"$x"-"$y".cs.wwu.edu
 exit
fi

# if on a personal computer 
if [[ $NODE != "cf*-*" && $NODE != "linux-*"  ]]; then
    file="./.SSH_last_uname.txt"
    if [ -z ${1+x} ]; then
        if [ -e "$file" ]; then
            uname=$(cat ./.SSH_last_uname.txt)
        else
            echo -n "Username: "
            read uname
            echo $uname > $file
        fi
    else
        uname=$1
        echo $uname > $file
    fi
    ssh -t -p922 $uname@linux.cs.wwu.edu ssh -p922 $(whoami)@cf"$x"-"$y".cs.wwu.edu
    exit 

# on a normal lab computer
else
    ssh -p922 $(whoami)@cf"$x"-"$y".cs.wwu.edu
fi


