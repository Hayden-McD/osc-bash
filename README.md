# Author Details:
Name: Hayden McDowall
Student code: mcdohr2
Last edited: 5/06/2021

#How to clone the repository
- First enter in the command line `git clone https://github.com/Hayden-McD/osc-bash.git`
- Secondly enter in the command line `cd osc-bash`

#Task One
##Summary
This script ingests a csv file specified by the user which contains information. This information is then taken by the script and used in various ways to create usernames, passwords, groups and folders. This script can create any ammount of users at a time.

##Pre-requisites
The only pre-requisite is to have a csv file containing information for the script including email, date of birth, groups and shared folder name.

##How to run the script
First make sure you are in the right directory. If you are in the directory for task2 enter `cd ..`
1. Enter in the command line `bash task1.sh`.
2. Enter the name of the csv file as requested by the script.
3. It will now display each users information. Check over the information and make sure it is all correct.
  - If the information is correct enter `Y` in the command line.
  - If the information is incorrect enter `N` in the command line and fix any errors in the csv file.
4. The script may now ask for a password. Enter the password and continue (Password for student is `P@ssw0rd`.
5. The script will now create a user with the:
  - Username and password displayed above.
  - Create any groups that dont exist then add the user to the specified group.
  - Create any folders that dont exist then links the useres folder ti their group folders.

#Task Two
##Summary
This script allows the user to select a file or folder to be compressed using tarball. This compressed file can then be transfered to a remote location using the users inputs. This is helpful when the user wants to backup a folder that can then be sent to another location incase of corrupt files or a power outage.

##Pre-requisites
There are no pre-requisites needed for this script

##How to run the script
First make sure you are in the right directory. If you are in the directory for task1 enter `cd ..`.
1. Enter in the command line `cd task2`.
2. Enter `bash task2.sh` to run the script.
3. Fill out the required fields as requested by the text on screen.
4. The script will then compress the file and send it to the destination specified by the user.
