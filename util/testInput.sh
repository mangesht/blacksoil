#!/usr/bin/sh
userName="mthakare"
if [ "$1" == "" ];then
        # Donothing 
        echo ""
else
        userName=$1
fi

echo "UserName " $userName
