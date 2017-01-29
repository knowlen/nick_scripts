#a: Nick Knowles
#d: 01/17/2017
#s: This script dispatches a bash command specified by the arguements to every* computer in the CF building.
#   Usage example: SSH_dispatch.sh kill -9 -1 
#       -kills all jobs you might have running on every machine.
#       -IMPORTANT: run mass kill from the linux cluster or script will kill itself before completion. 

#TODO:
#   -add current working machine exclusion, single machine inclusion. 
#   -add entire lab exclusion, single lab inclusion. 
#   -create FLAGS: -h for help 
#                  -m for single machine
#                  -l for single lab 
#                  -nl for lab exclusion
#                  -nm to ignore "my machine"
#                  -f for "find", grep the outputs of uname -a && w against $2 to find a person or who is on a machine. 
#   -figure out a way to grep uname -a and just get the cfxxx-xx for current machine exclusion.
#   -figure out how to dispatch jobs (open tmux, run, detatch, exit ssh) ssh, tmux, run, tmux detach-client, exit
#       NOTE: can try edditing .tmux config to run some job on startup, then call SSH_dispatch.sh "tmux new-session". Calling 
#             SSH_dispatch.sh "tmux kill-session" to stop them. Or same idea, but with bashrc? 

#look into screen for jobz: http://aperiodic.net/screen/quick_reference


#simple argparse by spaces
ARG=$1
TIME_O='7s' #time before giving up on shh connection.
#for i; do
#    ARG+=" $i";
#done

#help flag
if [ "$1" == "-h" ] || [ -z ${var+x} ]; then
    echo 'SSH Dispatch (h)'
    echo ' Primarily used to run commands on every computer in the CF building at WWU.'
    echo ' Flags [-f, -t, -h]'
    echo ' General Usage: ./SSH_dispatch.sh "some command to run"'
    echo ' Example: ./SSH_dispatch.sh "ls -l | grep Documents"'
    echo '-f: Find. Greps the department for some username, saves processes'
    echo '    belongning to that uname + the machines they are running on to'
    echo '    a file <find_uname_%YY%MM%DD.txt>.' 
    echo '    Usage: ./SSH_dispatch.sh -f "knowlen"'
    echo ' '
    echo '-t: Time. Sets the timout to kill ssh connections. Default: 7s.'
    echo '    Usage: ./SSH_dispatch.sh -t 1 command'
    echo ' '
    exit
fi


#set timout: handle flags
if [ $ARG == "-t" ]; then
    TIME_O=$2
    $ARG = $3
fi

#find username specified by 2nd arguement, save the machine & their processes to a unique file. 
if [ $ARG == "-f" ]; then
    TIME_O='3s'
    echo " " > $2'_find.txt' 
    ARG='w | grep '$2' && echo " " >> '$2'_find.txt && uname -n >> '$2'_find.txt && w >> '$2'_find.txt'
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

                echo "$lab 0$count"

            #grab machines 0-9
            timeout $TIME_O ssh -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 knowlen@$lab"-0$count".cs.wwu.edu $ARG 
            #grab machines 10-19
            if [ $lab != "cf408-hut" ]; then
                echo "$lab 1$count"
                timeout $TIME_O ssh -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 knowlen@$lab"-1$count".cs.wwu.edu $ARG
            fi
            #grab machines 20-29
            if [ $lab == "cf162" ]; then
                echo "$lab 2$count"
                timeout $TIME_O ssh -o "BatchMode yes" -oStrictHostKeyChecking=no -p922 knowlen@$lab"-2$count".cs.wwu.edu $ARG
            fi
       
        #let count=$count+1
    done
done

if [ "$1" == "-f" ]; then
    cat $2'_find.txt'
    mv $2'_find.txt' 'find_'$2'_'$(date +%Y%m%d)'.txt'
fi
