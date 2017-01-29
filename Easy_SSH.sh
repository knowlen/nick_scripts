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




