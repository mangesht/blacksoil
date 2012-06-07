#!/bin/sh 
username=mthakare
diskth=95
#mailsto=mthakare@cortina-systems.com,sysadmin-india@cortina-systems.com
time_interval=1800
usep=10
while [ $diskth > 0 ] 
do
date >> /home/mthakare/log/log.txt
sleep 1 
#qstat -u $username | grep MASTER | awk '{print $8 }' | sed -e 's/.q//g' | grep "" | while read output;
qstat -alarm | grep "\-\-\-\-\-\-\-\-\-\-" -A 1 | grep BIP | awk '{print $1 }' | sed -e 's/.q//g' | while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
cd /work/$output 
active_jobs=$(qstat -alarm | grep $output | awk '{ print $3 }' | sed -e "s/\/.*//g" | awk '{print $1 }  ')
echo -e "\n\n"
echo "Processing Machine $output Active jobs are " $active_jobs
if [ $active_jobs -gt 0 ] ; then 
    dp=$(df -H | grep $output | awk '{ print $5 } '| cut -d'%' -f1)
    echo $output $dp
    # Searched all active jobs dp has the the name of % disk status  $output has machine name 
    sleep 1 
    # echo $output $dp >> /home/mthakare/log/log.txt
      if [ $dp -ge $diskth ]; then
        echo "Running out of space \" $dp% \" on $output as on $(date)" 
        mailsto=mthakare@cortina-systems.com,sysadmin-india@cortina-systems.com
        ls -al /work/$output | awk '{print $9 }' | grep -v "\." | while read foldername;
        do 
           # Populates list of folder present at /work/$output 
           echo -e "\n"
           if [ "$foldername" != "" ]; then 
            # echo "foldername = " $foldername
            #foldername has foldername name 
            user=$(ls -al | grep "\<$foldername\>" | awk '{print $3}')
            # echo "user = " $user 
            if [ "$user" != "root" ]; then 
                disk_size=$(df \. -H   | grep $output | awk '{print $2 }')
                #echo "disk size of machine " $output "is " $disk_size  
                disk_in_g=$(echo $disk_size | grep G )
                if [ "$disk_in_g" != "" ]; then 
                    #echo "Disk Size in GB "
                     user_d_size=$(du -sh $foldername | awk '{print $1 }')
                     #echo "User Size = " $user_d_size 
                     user_size_in_g=$(echo $user_d_size | grep G)
                     if [ "$user_size_in_g" != "" ];then
                         #echo "foldername is also in G " $user_size_in_g 
                         disk_in_g=$(echo $disk_in_g |sed -e 's/G//g')
                         disk_in_g=$(echo $disk_in_g |sed -e 's/\.[0123456789]*//g')
                         user_size_in_g=$(echo $user_size_in_g |sed -e 's/G//g')
                         user_size_in_g=$(echo $user_size_in_g |sed -e 's/\.[0123456789]*//g')
                         user_perc=`expr $user_size_in_g \* 100 / $disk_in_g `
                         echo "User Size = " $user_size_in_g " GB Disk size = " $disk_in_g " GB User percentage  = " $user_perc "%"
                         if [ "$user_perc" -ge 30 ]; then
                            mailsto=$mailsto,$user@cortina-systems.com 
                            mailsto=mthakare@cortina-systems.com
                            mailsto=mthakare@cortina-systems.com,sysadmin-india@cortina-systems.com
                            echo -e "Running out of space  $dp%  on $output as on $(date) \n \v User Name  $user  \n \v Folder name is $foldername \n \v Using $user_size_in_g GB of diskspace out of available  $disk_in_g GB "| 
                            mail -s "Alert: Almost out of disk space $dp%" $mailsto
                            echo "Out " $mailsto
                            echo " $dp% on $output Mail sent to $mailsto at " $(date) "Active jobs " $active_jobs >> /home/mthakare/log/mail.txt 
                         fi 
                     else
                         echo "Folder size is NOT in GB "
                     fi
                fi # Disk not in G 
               fi 
           fi
        done 
      fi
    fi
done 
sleep $time_interval
done
