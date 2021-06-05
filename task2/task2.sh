#!/bin/bash
getInformation () {

read -p "Enter the directory path you would like to compress: " dir

read -p "Enter the username: " user

read -p "Enter the IP address or URL of remote server: " address

read -p "Enter the port number of the remote server: " port

read -p "Enter the destination directory path: " dest

compress $dir
}

send () {
sudo scp -P $port $1 $user@$address:"$dest"
}

compress () {

read -p "What would you like to call the backup file: " fileName

fileName+=".tar.gz"

sudo tar -czvf $fileName $1

send $fileName
}

getInformation
