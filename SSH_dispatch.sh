#!/usr/bin/env bash

#a: Nick Knowles
#d: Feb 18, 2017
#s: This script dispatches a bash command specified by the arguements to every* computer in the CF building.
#   Usage example: SSH_dispatch.sh kill -9 -1 
#       -kills all jobs you might have running on every machine.
#       -IMPORTANT: run mass kill from the linux cluster or script will kill itself before completion. 
#
#   Requirements/Dependencies:
#       -this script assumes you have your RSA key set up on the lab machines. 
#        See https://support.cs.wwu.edu/index.php/Setting_up_SSH_keys_in_Unix_Linux

FIND_NAME=$(whoami)
ARG=""
if [ -z "$1" -o $# -eq 0 ]; then
    ARG="--help"

else
    ARG=$1
fi

TIME_O='7s' #time before giving up on shh connection.

#for i; do
#    ARG+=" $i";
#done
HELP=""
if [ -r ~/.nk_dispatch/readme.txt ]; then
    HELP=$(cat ~/.nk_dispatch/readme.txt)
else
    HELP=$'
Usage: $./SSH_dispatch [OPTIONS] "command to run"
 
 OPTIONS [-h, -f, -t, -l] 
 -f, --find   Lists computers running processes belonging to a username. 
              If no username given, defaults to $(whoami).
               Usage: $./SSH_dispatch -f [some_username, ]
               Example: $./SSH_dispatch -f rsanchezC132
               '
    HELP=$HELP'
 -t, --time   Modify the time to wait before killing stalled ssh connections. 
               Default: 7s.
               Usage: $./SSH_dispatch -t [some # of seconds] "command"
               Example: $./SSH_dispatch -t 15 "pkill firefox"
              '
    
    HELP=$HELP'
 -l, --last   Only target the last N machines you have used.
              (requires install, see below)
               Usage: $./SSH_dispatch -l [number of machines]
               Example: $./SSH_dispatch -l 5
              '
   if [ "$1" != "install" ]; then
        HELP=$HELP' 
 install      Installs the nk_dispatch tool and all of its glory.
              The nk_dispatch tool propegates bash commands to every available
              machine accross the CF building at WWU.
               Usage/Example: $./SSH_dispatch install 
                              $ nk_dispatch [OPTIONS] "command"
                   '
    fi  
fi


# HELP arguement [--help, -h]
if [ $ARG == "-h" -o $ARG == "--help" ]; then
    if [ -r ~/.nk_dispatch/readme.txt ]; then
        echo "$HELP"
    else
        echo '
ssh_dispatch   This script installs the nk_dispatch tool, but can
               also work as a standalone script to take advantage 
               of most core nk_dispatch features.'
                         
        echo "$HELP"
    fi
    exit 
fi


#create a hidden dir ~/.nk_dispatch and coppy this script into there as nk_dispatch
#then  export PATH=$PATH:$~/.nk_dispatch/nk_dispatch
# INSTALL argument [install]
if [ $ARG == "install" ]; then
    BUILD_PATH=~/.nk_dispatch
    exec 2>/dev/null
    echo "Appending last_nodes logic to .bashrc..."
    echo 'NODE=$(uname -n)' >> ~/.bashrc
    echo 'if [[ $NODE != $(tail -n 1 .last_nodes.txt) ]];then' >> ~/.bashrc
    echo '       uname -n >> ~/.nk_dispatch/.last_nodes.txt &' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
    echo 'NODE=$(uname -n)' >> ~/.bash_profile
    echo 'if [[ $NODE != $(tail -n 1 .last_nodes.txt) ]];then' >> ~/.bash_profile
    echo '       uname -n >> ~/.nk_dispatch/.last_nodes.txt &' >> ~/.bash_profile
    echo 'fi' >> ~/.bash_profile
    echo "building dependencies..."
    mkdir $BUILD_PATH
    echo $(hostname) >> ~/.nk_dispatch/.last_nodes.txt
    echo "$HELP" > $BUILD_PATH/readme.txt 
    sed -i "s/\.\/SSH_dispatch.sh/nk_tools/g $BUILD_PATH/readme.txt"
    LINE=$(cat $BUILD_PATH/readme.txt | grep "install, see below")
    #sed -i "s/$LINE//g" $BUILD_PATH/readme.txt
    sed -i 25d $BUILD_PATH/readme.txt
    sed -i "1s/^/nk_dispatch\nAuthor: Nick Knowles (knowlen@wwu.edu)\nDate: Feb 18, 2017\n\nA general purpose tool used to distribute Bash commands\naccross a selected range of computers within the Computer Science\ndepartment's network at Western Washington University.\neg; (405 lab, 162 lab, ect..)\n/" $BUILD_PATH/readme.txt
    echo "Adding nk_dispatch to your path...."
    echo "export PATH=\$PATH:/home/$(whoami)/.nk_dispatch" >> ~/.bashrc
    echo "export PATH=\$PATH:/home/$(whoami)/.nk_dispatch" >> ~/.bash_profile 
    cp ./SSH_dispatch.sh $BUILD_PATH/nk_dispatch
    chmod +x $BUILD_PATH/nk_dispatch
    source ~/.bashrc
    echo "done."
    echo "See nk_dispatch --help for usage details."
    exit
fi

# LAST arguement [--last, -l]
if [ $ARG == "-last" -o $ARG == "-l" ]; then
    NODES=$(tail -n $2 ~/.last_nodes.txt)
    #TODO: except the current node (-1 off the tail)
    for i in $NODES
    do
    timeout $TIME_O ssh -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 $(whoami)@$i.cs.wwu.edu $3 
    done
fi

# TIMEOUT arguement [--time, -t]
if [ $ARG == "-t" -o $ARG == "-t" ]; then
    TIME_O=$2
    ARG=$3
fi

# FIND arguement [--find, -f]
if [ $ARG == "--find" -o $ARG == "-f" ]; then
    TIME_O='3s'
    if [ $# -gt 2 ]; then
        FIND_NAME=$2
    fi
    echo " " > ~/.nk_dispatch/finds/$FIND_NAME
    FP='~/.nk_dispatch/finds/'$FIND_NAME
    ARG='w | grep '$FIND_NAME' && echo " " >> '$FP' && uname -n >> '$FP' && w >> '$FP
fi

LABS=( "cf162" "cf408-hut" "cf405" "cf418" "cf416" )
#count=1
for lab in "${LABS[@]}"
do
        count=0
        if [ $lab == "408-hut" ]; then
            let $count=1;     
        fi
        #for lab 0~9
        for (( count; count<=9; count++ )) do
            if [ "$2" == $lab"-"$count ]; then
                $count=$count+1
            fi
                echo "$lab 0$count: $ARG"
            #grab machines 0-9
            $(timeout $TIME_O ssh -f -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 $(whoami)@$lab"-0$count".cs.wwu.edu $ARG 2>&-) & 
            #grab machines 10-19
            if [ $lab != "cf408-hut" ]; then
                echo "$lab 1$count: $ARG"
                $(timeout $TIME_O ssh -f -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 $(whoami)@$lab"-1$count".cs.wwu.edu $ARG 2>&- 1>&-) &
            fi
            #grab machines 20-29
            if [ $lab == "cf162" ]; then
                echo "$lab 2$count: $ARG"
                $(timeout $TIME_O ssh -f -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 $(whoami)@$lab"-2$count".cs.wwu.edu $ARG 2>&- 1>&-) &
            fi
        #let count=$count+1
    done
done

# file handling for FIND
if [ "$1" == "-f" ]; then
    cat ~/.nk_dispatch/finds/$FIND_NAME
    FN='~/.nk_dispatch/finds/'$FIND_NAME'_'$(date +%Y%m%d)'.txt'
    mv ~/.nk_dispatch/finds/$FIND_NAME $FN
    echo 'This output has been archived to'$FN
fi
