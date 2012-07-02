#!/bin/sh 
diskname='/work/ins072'
diskth=10
mailsto=mthakare@gmail.com
# Author : mthakare@gmail.com
# Disclaimer : Touch the part below at your Own risk 
# Auther Does not take any guarantee / warranty of the utility. Any service request should not be raised to Author.
# Copyleft : You are free to use, distribute, change the contents or do what ever you wish...

df -H | grep -E $diskname | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  echo $usep 
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $diskth ]; then
    echo "Mangesh " 
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
     mail -s "Alert: Almost out of disk space $usep%" to-addr $mailsto
  fi
done 
