### nick_scripts
This is a repository to house simple, but useful scripts I've created for myself or friends.   
(mostly WWU related productivity hacks)  
Run any script with a -h flag for a usage guide.  
_Disclaimer: These scripts are often brute force solutions to problems I want to solve in the moment. If you try to read the code, it's going to reflect that. 90% of the time I spend on this repo will go towards documentation._  

#### SSH_dispatch.sh
A general purpose script that broadcasts a Bash command to every machine on the CS department network at Western Washington University.
 Forced to use Chromium because you forgot to close Firefox at some point in your undergraduate career? Well not anymore! 
Load this bad boy up and run __$nk_dispatch "pkill firefox"__  
##### install
```bash
$git clone https://github.com/knowlen/nick_scripts.git     
$cd ./nick_scripts     
$./SSH_dispatch.sh install
$rm -rf ./nick_scripts
$nk_dispatch
```  

Most of the core functionality will work out of the box with just the script (eg; $./SSH_dispatch.sh "pkill firefox" will still kill every instance of firefox you're running on the network), installing this just allows you to call nk_dispatch from anywhere & keeps a list of your last used machines so you can do things like __$nk_dispatch --last 4 "kill -9 -1"__ to nuke all jobs on the last 4 machines you used.  

#### Easy_SSH
A simple interface for SSH that makes getting to whatever node you're trying to get to at WWU a little faster. You can also run __$./Easy_SSH install__ on this one and call commands like  __$easy_ssh 405 08__ to immediatley access machine 8 in CF405 from anywhere, even from your home computer! _(assuming you have Bash, Windows 10 and every other OS has bash -fyi)_. 
