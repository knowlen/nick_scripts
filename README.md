### nick_scripts
This is a repository to house simple, but useful scripts I've created for myself or friends.   
(mostly WWU related productivity hacks)  
Run any script with a -h flag for a usage guide. 


#### SSH_dispatch.sh
A general purpose script that broadcasts a Bash command to every machine on the CS department network at Western Washington University.
 Forced to use Chromium because you forgot to close Firefox at some point in your undergraduate career? Well not anymore! 
Load this badboy up and run __$nk_dispatch "pkill firefox"__  
##### install
```bash
$git clone https://github.com/knowlen/nick_scripts.git     
$./SSH_dispatch.sh install     
$nk_dispatch
```  

Most of the core functionality will work out of the box with just the script (eg; $./SSH_dispatch.sh "pkill firefox" will still kill every instance of firefox you're running on the network), installing this just allows you to call nk_dispatch from anywhere & keeps a list of your last used machines so you can do things like __$nk_dispatch --last 4 "kill -9 -1"__ to nuke all jobs on the last 4 machines you used.  
