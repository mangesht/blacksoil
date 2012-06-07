#!/bin/sh 
username=mthakare
diskth=95
#mailsto=mthakare@cortina-systems.com,sysadmin-india@cortina-systems.com
time_interval=1200
usep=10
while [ $diskth > 0 ] 
do
date >> /home/mthakare/log/log.txt
sleep 2 
#qstat -u $username | grep MASTER | awk '{print $8 }' | sed -e 's/.q//g' | grep "" | while read output;
qstat -alarm | grep "\-\-\-\-\-\-\-\-\-\-" -A 1 | grep BIP | awk '{print $1 }' | sed -e 's/.q//g' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
cd /work/$output 
active_jobs=$(qstat -alarm | grep $output | awk '{ print $3 }' | sed -e "s/\/.*//g" | awk '{print $1 }  ')
echo "Active jobs are " $active_jobs
if [ $active_jobs -ge 0 ] ; then 
    dp=$(df -H | grep $output | awk '{ print $5 } '| cut -d'%' -f1)
    echo $output $dp
    sleep 1 
    # echo $output $dp >> /home/mthakare/log/log.txt
      if [ $dp -ge $diskth ]; then
        echo "Running out of space \" $dp% \" on $output as on $(date)" 
        mailsto=mthakare@cortina-systems.com,sysadmin-india@cortina-systems.com
        ls -al /work/$output | awk '{print $3 }' | grep -v root | while read user;
        do 
           if [ "$user" != "" ]; then 
            mailsto=mthakare@cortina-systems.com,sysadmin-india@cortina-systems.com
            mailsto=$mailsto,$user@cortina-systems.com 
            echo "Running out of space \" $dp% \" on $output as on $(date)" | 
            mail -s "Alert: Almost out of disk space $dp%" $mailsto
            echo "Out " $mailsto
            echo " $dp% on $output Mail sent to $mailsto at " $(date) "Active jobs " $active_jobs >> /home/mthakare/log/mail.txt 
           fi 
        done 
      fi
    fi
done 
sleep $time_interval
done
