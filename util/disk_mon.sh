#!/usr/bin/sh
diskth=80
mailsto=mthakare@cisco.com
diskname=$1
while [ 1 ] 
do
    used=$(nquota | grep $diskname  | awk '{print $2 }' | sed -e "s/G//g" | sed -e "s/ //g" | sed -e "s/\..*//g")
    alloted=$(nquota | grep $diskname  | awk '{print $3 }' | sed -e "s/G//g" | sed -e "s/ //g" | sed -e "s/\..*//g")
    echo " 2-"$used"--" 
    echo " 3 " $alloted
    perc_use=`expr $used \* 100 / $alloted`
    echo "%Use = " $perc_use
    if [ $perc_use -ge $diskth ]; then
           echo "Running out of Space on $diskname Usage = \"  ($perc_use%) \"as on $(date)" | mail -s " Alert : Running out of disk Space $perc_use%" $mailsto
    fi
    sleep 900 
done

