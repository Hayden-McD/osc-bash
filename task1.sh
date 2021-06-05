#!/bin/bash


createUsers (){
if sudo grep -q ${username[$x]} /etc/passwd; then
        echo "This user already exists..."
else
        sudo useradd -d /home/${username[$x]} -m -s /bin/bash ${username[$x]}
        echo ${username[$x]}:${password[$x]} | sudo chpasswd
        sudo chage -d0 ${username[$x]}
fi
}

createGroups (){
if [ -z "${userGroups[$x]}" ]; then
        echo "No group specified for user ${username[$x]}, Assigning to default group."
        sudo groupadd default 2> /dev/null

        #Creating and assigning users to default group
        if [ $? -eq 0 ]; then
                echo "Group 'default' created"
                sudo usermod -a -G default ${username[$x]}
                echo "User ${username[$x]} added to default group"
        else
                sudo usermod -a -G default ${username[$x]}
                echo "User ${username[$x]} added to default group"
	fi

elif grep -q ${userGroups[$x]} /etc/group; then
        echo "The group ${group[$x]} already exists."
        sudo usermod -a -G ${userGroups[$x]} ${username[$x]}
        echo "Assigned ${username[$x]} to group ${userGroups[$x]}."
else
        echo "Creating group ${userGroups[$x]}."
        sudo groupadd "${userGroups[$x]}"
        sudo usermod -a -G ${userGroups[$x]} ${username[$x]}
        echo "Assigned ${username[$x]} to group ${userGroups[$x]}."

fi
}

createFolders (){
if [ -z "${userFolder[$x]}" ]; then

	echo "No folder has been given for the user: ${username[$x]}, Adding to default folder: /sharedDefault"
	sudo mkdir /home/sharedDefault 2> /dev/null

	if [ $? -eq 0 ]; then
		echo "Default folder has been created."

	elif [ -z ${userFolder[$x]} ]; then
		sudo chgrp -R default /home/sharedDefault
		sudo chmod -R 2775 /home/sharedDefault
		sudo ln -s /home/sharedDefault /home/${username[$x]}
		if [ $? -eq 0 ]; then
			echo "Link created"
		fi

	else
		sudo chgrp -R ${userFolder[$x]} /home/sharedDefault
		sudo chmod -R 2775 /home/sharedDefault
		sudo ln -s /home/sharedDefault /home/${username[$x]}	
		if [ $? -eq 0 ]; then
			echo "Link Created"
		fi
	fi

elif [ -d /home${userFolder[$x]} ]; then
	echo "The folder for user: ${username[$x]} already exists"
	sudo chgrp -R ${userGroups[$x]} /home${userFolder[$x]}
	sudo chmod -R 2775 /home${userFolder[$x]}
	sudo ln -s /home${userFolder[$x]} /home/${username[$x]}
	
	if [ $? -eq 0 ]; then
		echo "Link created"
	fi

else
	echo "Creating folder for user: ${username[$x]}"
	sudo mkdir /home${userFolder[$x]}
        sudo chgrp -R ${userGroups[$x]} /home${userFolder[$x]}
        sudo chmod -R 2775 /home${userFolder[$x]}
 	sudo ln -s /home${userFolder[$x]} /home/${username[$x]}

        if [ $? -eq 0 ]; then
                echo "Link created"
        fi
fi
}

readFile () {
#Variables
numOfUsers=0

read -p "Please enter the csv file name: " uploadedFile

#Generating username, password, groups and shared folder for each user listed in the csv file.
while IFS="," read -r email DOB groups sharedFolder
do : 
	#Generating the  username of each user by taking their last name supplied by the email and the first character
	#of their email.

	lastName=$(echo "$email" | sed 's/^[^.]*.//' | sed 's/@.*//')
	firstChar=${email:0:1}
	username+=("$firstChar$lastName")

	#Generating the password for each user by taking the last 4 digits of the users date of birth (minus any '/'
	#and then appends the whole users date of birth minus the '/'.

	month=$(echo "${DOB:5}"  | sed 's/[/].*//') #Only keeps characters after the 5th and removes the '/'
	year=$(echo "$DOB" | sed 's/[/].*//')
	password+=("$month$year")

	userGroups+=("$groups")
	userFolder+=("$sharedFolder")

	let numOfUsers++
done < <(tail -n +2 $uploadedFile)

for x in "${!username[@]}"
do : 
	echo "PLEASE CHECK THE FOLLOWING TO CONFIRM THE DETAILS ARE CORRECT"
	echo "USERNAME: ${username[$x]}"
	echo "PASSWORD: ${password[$x]}"
	echo "GROUPS: ${userGroups[$x]}"
	echo "SHARED FOLDER: ${userFolder[$x]}"
done

echo "There are ${numOfUsers} that will be created"
read -p "Do you wish to continue? (Y/N)" continue

case "$continue" in
	[Yy])
	echo "Now creating the users..."
	 runLoop
	;;
	[Nn])
	echo "Now exiting the script..."
	exit 0
	;;
esac
}

runLoop (){
for x in "${username[@]}"
do
createUsers
createGroups
createFolders
done
}

readFile
