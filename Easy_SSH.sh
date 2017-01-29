#a: Nick Knowles (knowlen@wwu.edu)
#d: Winter 2017
#
# This script will connect you to the linux cluster if outside cf.
# Prompt for a username upon first use (save & recall for future uses).
# Optionally, you can hand it your username as an arguement (do this if you
# enter wrong username for first invocation). 
# Prompts for room and machine number, then connects to that machine.

if [ "$1" == "-h" ]; then
    echo "Easy SSH (h)"
    echo "Usage1: ./Easy_SSH.sh"
    echo "Usage2: ./Easy_SSH.sh <username>"
    echo "NOTE:"
    echo "     If having problems connecting, run Usage2 until you type your"
    echo "     username correctly." 
    exit
fi



# if not in the departmenti
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
NODE="$(uname -n)"
if [[ $NODE != "cf"*"-"* ]]; then
    ssh -p922 $uname@linux.cs.wwu.edu
    exit 
fi

echo -n "room #: "
read x
echo -n "pc #: "
read y

#special case
if [ "$x" == "408" ]; then
    ssh -p922 $uname@cf408-hut-"$y".cs.wwu.edu
else
    ssh -p922 $uname@cf"$x"-"$y".cs.wwu.edu
fi




