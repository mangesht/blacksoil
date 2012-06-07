#!/bin/bash 
echo -e "usage \t  user "
total=10
usage=0
myt=0
qstat_(){
total=0
tmp_data_file_name="jaiSouffRam"
# echo ${#last_user[@]}
qstat -u "*"| grep india | awk '{print $4 } ' | sort | uniq | while read output;
do
    usage=$(qstat -u $output | grep india -c )
    #total=`expr $usage + $total`
    let total=$usage+$total 
    echo -e $usage "\t" $output
    echo $total > $tmp_data_file_name
done
return $total
}

qstat_
total=$(grep "" $tmp_data_file_name)
rm -f $tmp_data_file_name
echo "----------------------------------------"
echo -e "Total " $total
