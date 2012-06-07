#!/bin/sh 
mailsto=mthakare@cortina-systems.com 
usep=10
ls | while read output ; 
do 
    if [ $usep -ge 0 ]; then 
        mail -s "Work Done - Mangesh $1 " $mailsto
    fi 
done 
