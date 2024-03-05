#!/bin/bash


#adduser
adduser() {
        read -p "Enter username: " username
        id $username &>/dev/null
        while [ $? -eq 0 ]
        do
                username=${username}${RANDOM}
                id $username &>/dev/null
        done
        sudo useradd $username
        read -p "Enter password: " password
        echo $password | passwd --stdin $username
        echo "User $username added successfully"
}


#userdelete
deluser() {
        read -p "Enter the user" username
        sudo userdel $username
}

#user details
usershow() {
        read -p "Enter username:" username
        sudo chage -l $username
}

#enableusers
enableuser(){
        read -p "Enter username:" username
        sudo usermod -U $username
}

#disableusers
disableuser() {
        read -p "Enter username:" username
        sudo usermod -L $username
}

#listusers
listusers(){
        echo "The list of users:        \n"
        cut -d: -f1 /etc/passwd
}

#changeuserpassword
chpassword(){
        read -p "Enter username:" username
        sudo passwd $username
}


#add group 
groupadd(){
        read -p "Enter group name :" group
        sudo groupadd $group
        echo "$group added successfully"
}

#groupdelete 
deletegroup() {
        read -p "Enter group name :" group
        sudo groupdel $group
        echo "$group deleted  successfully"
}

#addusertogroup 
addUtoG() {
        read -p "Enter username:" username
        read -p "Enter groupname:" group
       if getent group $group > /dev/null; then
       echo "$group exists "
       gpasswd -a $username $group
       echo "$username added to $group successfully"
else
        echo "$group does not exist, creating one"
        sudo groupadd $group
        gpasswd -a $username $group
        echo " $username added to $group successfully"
       fi

}

#deleteuserfromgroup 
deleteUfromG() {
       	read -p "Enter username:" username
        read -p "Enter groupname:" group
       if getent group $group > /dev/null; then
       gpasswd -d $username $group
       echo "$username removed from $group successfully"
else 
	echo "$group does not exist!"
       fi 
}


#listgroup
listgroups() {
cut -d: -f1 /etc/group 
}


#menu 
select variable in " Add User " " Delete User " " List Users " " Show User's Details " " Change User's Password " " Enable User's Account " " Disable User's Account " " Add Group " " Delete Group " " Add User To Group " " Delete User From Group " " List Goups " " Exit "
do 
	case $variable in 
		" Add User " ) adduser ;;
		" Delete User " ) deluser ;;
		" List Users " ) listusers ;; 
		" Show User's Details " ) usershow ;;
		" Change User's Password " ) chpassword ;;
		" Enable User's Account " )  enableuser ;;
         	" Disable User's Account " ) disableuser ;;
		" Add Group " ) groupadd ;;
		" Delete Group " ) deletegroup ;;
		" Add User To Group " ) addUtoG ;;
		" Delete User From Group " ) deleteUfromG;;
		" List Groups " ) listgroups ;;
		" Exit " )  exit ;;
	esac 
done 







