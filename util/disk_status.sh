#!/usr/bin/sh

while [ 1 ] 
do
    du -sh * | mail -s "Disk Status " mthakare
    sleep 3600 
done

