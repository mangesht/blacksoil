#!/bin/sh 
mailsto=mthakare@cortina-systems.com,preeti.vidhate@microchip.com,preeti.vidhate@gmail.com
usep=10
ls  | while read output ; 
do 
    if [ $usep -ge 0 ]; then 
        mail -s " Its time for Iron Capsure " $mailsto
    fi 
done 
