#!/bin/bash 

if [ "$(whoami)" == "root" ]; then
    if [ "$1" == "" ]; then 
       echo "Please pass the .py which can find inside the security.microsoft.com"
   
    else 
        sudo apt update
        sudo apt install curl libplist-utils gpg apt-transport-https -y

        wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb
        dpkg -i packages-microsoft-prod.deb
        rm -rf packages-microsoft-prod.deb

        sudo apt update
        sudo apt install mdatp -y 
        mdatp connectivity test
        python3 $1

        if [ "$(mdatp health | cut -d ":" -f 2 | head -n1 | sed 's/ //g')" == "true" ]; then 
            clear
            echo "[+] Onboarded"

        else 
            clear
            echo "[-] No Onboarded" 
        fi
    fi 
else
    echo "use root user"

fi
