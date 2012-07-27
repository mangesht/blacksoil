#!/usr/bin/sh
userName="mthakare"
if [ "$1" == "" ];then
        # Donothing 
        echo ""
else
        userName=$1;
fi
while [ 1 ] 
do
    numjobs=$(bjobs -u $userName | grep argus | grep normal -c )
    status=$(bjobs -u $userName | grep normal | awk '{print $3 }')
    if [ $numjobs -eq 0 ];then 
        echo "NumJobs = " $numjobs $status  
        break 
    else
        echo "NumJobs = " $numjobs  $status
    fi
    sleep 30
done
pwd | mail -s "Regression done " mthakare 

