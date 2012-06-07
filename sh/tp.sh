#!/bin/sh
diskname='/work/mon'
diskname2='/work/ins047'
diskth=80
mailsto=mthakare@cortina-systems.com,mangesh.thakare@gmail.com,lokesha@cortina-systems.com,rganesha@cortina-systems.com,kbondali@cortina-systems.com
# Author : mthakare@cortina-systems.com
# Disclaimer : Touch the part below at your Own risk 
# Auther Does not take any guarantee / warranty of the utility. Any service request should not be raised to Author.
# Copyleft : You are free to use, distribute, change the contents or do what ever you wish...

disk3=$(cat $diskname , $diskname2 )
echo $diskname 
echo $diskname2
echo $disk3
# find ./ -name basic.rules |xargs grep min_packet | awk '{print $5}'| while read output;
# do
#   echo $output
#   if [ $output -ge 150 ] 
#   then
#     echo "Packet size more than 50 = " $output 
#   else 
#     echo "Packet size less than 50 = " $output 
#   fi
# done 

