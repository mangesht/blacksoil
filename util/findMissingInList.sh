#!/usr/bin/sh
rm -f temp.findMissing

id=26
if [ "$1" != "" ];then
        id=$1
fi
echo "ID  = " $id

evo regr list -id=$id > temp.findMissing
echo "Regression Test not in compile List "
grep " T " temp.findMissing |awk '{print $3}' | while read output;
do
    #echo "Test Id  = " $output 
    testName=$(evo test list -id=$output -verbose | grep "Test Cmd" | awk '{print $5}')
    #echo testName 
    res=$(grep $testName agsL2IgrList)
    if [ "$res" != "" ];then
            a=""
    else
            echo $testName 
    fi
done

