#!/bin/bash

if [ $(whoami) == "root" ]; then
    if [ $1 == "" ] || [ $2 == "" ]; then
        echo "WARNING, ONLY WORKS IF THE DISTRO IS DEBIAN BASED"
        echo "bash onboarding.sh debian|ubuntu onboardingScriptName.py"

    else
        sudo apt update 
        sudo apt upgrade -y

        sudo apt install curl libplist-utils gpg apt-transport-https -y 

        if [ $1 == "debian" ]; then 
            version=$(cat /etc/os-release | grep "VERSION_ID" | cut -d "=" -f 2 | sed 's/\"//g')  

            curl -o microsoft.list https://packages.microsoft.com/config/ubuntu/$version/prod.list
            
            if [ $? -ne 0 ]; then 
                echo "Probably your version aren't available in the microsoft repository"
                exit 1
            fi 
        
            sudo mv microsoft.list /etc/apt/sources.list.d/microsoft-prod.list
            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

            sudo apt update 
            sudo apt install mdatp -y

            clear
            
            mdatp connectivity test
            python3 $2
            
            if [ $(mdatp health | cut -d ":" -f 2) == "true" ]; then
                echo "Onboarded, it can take a hour to apper inside the security.microsoft.com" 
                exit 0
            
            else 
                echo "Something went wrong"
                exit 1
            fi

        elif [ $1 == "ubuntu" ]; then 
            version=$(cat /etc/os-release | grep "VERSION_ID" | cut -d "=" -f 2 | sed 's/\"//g')  

            curl -o microsoft.list https://packages.microsoft.com/config/ubuntu/$version/prod.list
            
            if [ $? -ne 0 ]; then 
                echo "Probably your version aren't available in the microsoft repository"
                exit 1
            fi 
        
            sudo mv microsoft.list /etc/apt/sources.list.d/microsoft-prod.list
            curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

            sudo apt update 
            sudo apt install mdatp -y

            clear

            mdatp connectivity test
            python3 $2
            
            if [ $(mdatp health | cut -d ":" -f 2) == "true" ]; then
                echo "Onboarded, it can take a hour to apper inside the security.microsoft.com" 
                exit 0
            
            else 
                echo "Something went wrong"
                exit 1
            fi

        else 
            echo "Distro unavailable"
            exit 1
        fi 
    fi 

else
    echo "Please execute like root"
    exit 1

fi 