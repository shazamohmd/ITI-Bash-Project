#!/bin/bash

# adduser
adduser() {
username=$(whiptail --title "Add user" --inputbox "Please enter a username: " 10 40 3>&1 1>&2 2>&3)
if [ $? -eq 0 ]; then
id $username >/dev/null 2>&1

if [ $? -eq 0 ]; then
whiptail --title "Add user" --msgbox "user already exists." 10 40

else
sudo useradd $username
password=$(whiptail --title "Add user" --inputbox "please enter a password" 10 40 3>&1 1>&2 2>&3) 
echo $password | passwd --stdin $username
whiptail --title "Add user" --msgbox "user $username added successfully" 10 40
#echo "User $username added successfully"
fi
fi
}

# delete user
deleteuser() {
username=$(whiptail --title "Delete user" --inputbox "Please enter the username you want to delete"  10 40 3>&1 1>&2 2>&3)
sudo userdel $username
whiptail --title "Delete user" --msgbox "$username deleted sucessfully" 10 40
}

# show user details
userdetails() {
username=$(whiptail --title "Show user details" --inputbox "Please enter username" 10 40 3>&1 1>&2 2>&3)
chage -l $username > /tmp/userdetails.txt
whiptail --title "Show user details" --textbox /tmp/userdetails.txt 20 70
rm /tmp/userdetails.txt
}

# list users
listusers() {
cut -d: -f1 /etc/passwd > /tmp/listusers.txt
whiptail --title "List of users" --scrolltext --textbox /tmp/listusers.txt 40 60
rm /tmp/listusers.txt
}

# enable user account
enableuser() {
username=$(whiptail --title "Enable user account" --inputbox "Please enter username" 10 40 3>&1 1>&2 2>&3)
sudo usermod -U $username
whiptail --title "Enable user account" --msgbox "$username account enabled" 10 40
}

# disable user account
disableuser() {
username=$(whiptail --title "Disable user account" --inputbox "Please enter username" 10 40 3>&1 1>&2 2>&3)
sudo usermod -L $username
whiptail --title "Disable user account" --msgbox "$username account disabled" 10 40
}


# change user's password
changepassword() {
username=$(whiptail --title "Change user password" --inputbox "Please enter username" 10 40 3>&1 1>&2 2>&3)
password=$(whiptail --title "Change user password" --inputbox "please enter a new password" 10 40 3>&1 1>&2 2>&3) 
echo $password | passwd --stdin $username

#sudo passwd $username

whiptail --title "Change user password" --msgbox "$username password updated" 10 40
}

# add group
addgroup() {
groupname=$(whiptail --title "Add group" --inputbox "Please enter groupname" 10 40 3>&1 1>&2 2>&3)
sudo groupadd $groupname
whiptail --title "Add group" --msgbox "$groupname added successfully" 10 40
}

# delete group
deletegroup() {
groupname=$(whiptail --title "Delete group" --inputbox "Please enter groupname" 10 40 3>&1 1>&2 2>&3)
sudo groupdel $groupname
whiptail --title "Delete group" --msgbox "$groupname deleted sucessfully" 10 40
}

# add user to group
addusergroup() {
username=$(whiptail --title "Add user to group" --inputbox "Please enter username" 10 40 3>&1 1>&2 2>&3)
groupname=$(whiptail --title "Add user to group" --inputbox "Please enter groupname" 10 40 3>&1 1>&2 2>&3)
if getent group "$groupname" > /dev/null; then
  gpasswd  -a $username $groupname
  whiptail --title "Add user to group" --msgbox "$username added to $groupname successfully!" 10 40
else
  whiptail --title "Add user to group" --msgbox "$groupname does not exists, creating one!" 10 40
  sudo groupadd $groupname
  gpasswd  -a $username $groupname
  whiptail --title "Add user to group" --msgbox "$username added to $groupname successfully!" 10 40
fi
}


# delete user from group
deleteusergroup() {
username=$(whiptail --title "Delete user from group" --inputbox "Please enter username" 10 40 3>&1 1>&2 2>&3)
groupname=$(whiptail --title "Delete user from group" --inputbox "Please enter groupname" 10 40 3>&1 1>&2 2>&3)
if getent group "$groupname" > /dev/null; then
  gpasswd  -d $username $groupname
  whiptail --title "Delete user from group" --msgbox "$username removed from $groupname successfully!" 10 40
else
  whiptail --title "Delete user from group" --msgbox "$groupname does not exists, please try again!" 10 40
fi
}

# list groups
listgroups() {
cut -d: -f1 /etc/group > /tmp/listgroups.txt
whiptail --title "List groups" --textbox /tmp/listgroups.txt 20 70 --scrolltext --ok-button "Ok"
rm /tmp/listgoups.txt
}

# Menu
while true; do
option=$(whiptail --title "Bash project" --menu "choose an option" 25 80 16 \
"Add user" "Add user to the system" \
"Delete user" "Remove user from the system" \
"Show user details" "Dispaly user info" \
"List users" "Display users names" \
"Enable user" "Unlock user's account" \
"Disable user" "Lock user's account" \
"Change user's password" "Reset user's password" \
"Add group" "Add group to the system" \
"Delete group" "Remove group from the system" \
"Add user to group" "Add user to a group" \
"Delete user from group" "Remove user from group" \
"List groups" "Display group names" \
"Exit" "Close menu" 3>&1 1>&2 2>&3)

if [ $? -eq 0 ]; 
then
case $option in
"Add user") adduser ;;

"Delete user") deleteuser;;

"Show user details") userdetails;;

"List users") listusers;;

"Enable user") enableuser;;

"Disable user") disableuser;;

"Change user's password") changepassword;;

"Add group") addgroup;;

"Delete group") deletegroup;;

"Add user to group") addusergroup;;

"Delete user from group") deleteusergroup;;

"List groups") listgroups;;

"Exit")
break ;;

esac

fi

done
