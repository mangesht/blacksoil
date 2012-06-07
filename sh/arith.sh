#!/bin/sh 
mailsto=mthakare@cortina-systems.com 
usep=10
one=3
lic_file=/home/mthakare/utility/use_mail.ini
num_use=10
ans=`expr $num_use + $one`
echo "Addition = " $ans
ans=`expr $num_use - $one`
echo "Substraction = " $ans
ans=`expr $num_use \* $one`
echo "Multipliction = " $ans
ans=`expr $num_use / $one`
echo "Division  = " $ans
ans=`expr $num_use \* 100 / $one`
echo "Mult Division  = " $ans


echo $num_use 
    if [ $usep -ge 0 ]; then 
        output=$num_use
        echo $output
        # mail -s "Work Done - Mangesh $1 " $mailsto
    fi 

