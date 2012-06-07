#!/bin/sh 
mailsto=mthakare@cortina-systems.com,sawan.ruparel@gmail.com
usep=10
grep "" /home/mthakare/message_sa.txt | while read output ; 
do 
    if [ $usep -ge 0 ]; then 
        mail -s " Its time for Homiopathy " $mailsto
    fi 
done 
