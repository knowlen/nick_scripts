#!/usr/bin/env bash

working_copy_path="~/.home_svn/path_to_dir.txt"
uname=
path=


new_dir (){
	working_copy_path="~/.home_svn/path_to_dir.txt"
	echo -n "Username: "
	read uname
	echo $uname > $file
	echo -n "Username: "
	read path_to_repo
	echo $path_to_repo >> $file
}

get_path_uname (){
	uname=$(head -n 1 $working_copy_path)
	path=$(tail -n 1 $working_copy_path)
	echo "Is $path the correct working directory?: "
	OPTIONS="y n"
	select opt in $OPTIONS;
	if [ "$opt" = "n" ]; then
		new_dir
		get_path_uname
	fi

	
}
working_copy_path="~/.home_svn/path_to_dir.txt"
if [[ -e "$file" ]]; then
	uname=$(head -n 1 $working_copy_path)
	path=$(tail -n 1 $working_copy_path)
	echo "Is $path still the correct working directory?: "
	OPTIONS="y n"
	select opt in $OPTIONS;
	if [ "$opt" = "n" ]; then
		new_dir
		get_path_uname
	fi
else
	new_dir
	get_path_uname
		
fi
scp -P922 $1 $uname@linux.cs.wwu.edu:$path_to_repo
echo "Committing..." 
ssh -f -o "BatchMode yes" -o StrictHostKeyChecking=no -p922 $uname@linux.cs.wwu.edu "cd $path; svn ci -m $2; svn up; svn log" 
echo "Done."


