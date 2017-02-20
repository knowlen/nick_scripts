#!/usr/bin/env bash

# Author: Nick Knowles (knowlen@wwu.edu, github.com/knowlen)
# Date: Winter 2017
# 
# A general SSH script I use to make getting
# from node A to node B on the WWU CS dept 
# network a little quicker.
#

if [ "$1" == "-h" ]; then
    echo
    echo "Easy SSH (h)  A quick SSH interface to use within the Computer Science 
              department at Western Washington University 
    "
    echo "Usage (cli): $./Easy_SSH.sh [room] [machine]"
    echo " Example: $./Easy_SSH.sh 405 08
    "
    echo "Usage (interactive): $./Easy_SSH.sh
    "
    echo "Usage (first time from personal computer): $./Easy_SSH.sh [CS username]"
    echo " Example: $./Easy_SSH.sh sanchezR132"
    echo " NOTE: The script remembers username after first use.
    "
    echo " 
   OPTIONS:
   install  Adds the program to your path as 'cf' so it can be called
            easily from wherever. 
            Usage/Example: $./Easy_SSH install
                           $ cf [lab] [machine] 

  "
    exit
fi

if [ "$1" == "install" ]; then
    mkdir ~/.easy_ssh
    cp ./Easy_SSH.sh ~/.easy_ssh/cf
    echo "export PATH=/home/$(whoami)/.easy_ssh:\$PATH" >> ~/.bashrc
    echo "export PATH=/home/$(whoami)/.easy_ssh:\$PATH" >> ~/.bash_profile
    echo "done."
    echo 'Usage: $cf [lab] [machine]'
    source ~/.bashrc
    exit
fi
if [ $# -lt 2 ]; then
    echo -n "room #: "
    read x
    echo -n "pc #: "
    read y
else
    x=$1
    y=$2
fi

# hutch_research student
if [ "$x" == "408" ]; then
    x="408-hut"
fi

NODE="$(uname -n)"

# if on a research machine
if [[ $NODE == "cf408-"* ]]; then
 PWD=$(pwd)
 ssh -t -p922 $(whoami)@linux.cs.wwu.edu ssh -p922 $(whoami)@cf"$x"-"$y".cs.wwu.edu
 exit
fi
if [[ $NODE == "cf"* || $NODE == "linux"* ]]; then 
    ssh -p922 $(whoami)@cf"$x"-"$y".cs.wwu.edu
    exit
else
# if on a personal computer 
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
fi


