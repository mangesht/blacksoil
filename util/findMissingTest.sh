#!/usr/bin/sh
rm -f temp.findMissing
id=26
if [ "$1" != "" ];then
        id=$1
fi
echo "ID  = " $id
evo test list -all -verbose | grep "^Name" | awk '{print $3}' > temp.findMissing

echo "Test present in List and not in Evo " 
grep "" agsL2IgrList | sed -e "s/\.sv//g" | while read output;
do
        #echo " Searching " $output
        res=$(grep $output temp.findMissing )
        #echo result $res
        if [ "$res" != "" ];then
                #echo "Test present in List and not in Evo " $output
                a=""
                #echo $a
        else
                echo "  " $output
        fi
done
echo ""
echo ""
echo ""
echo "Test present in List and not in Regression List " 
rm -f temp.findMissing
evo regr list -id=$id > temp.findMissing
grep "" agsL2IgrList | sed -e "s/\.sv//g" | grep -v "#"| while read output;
do
        #echo "processing $output"
        m=`expr substr $output 1 30`
        #echo $m
        res=$(grep $m temp.findMissing )
        #echo result $res
        if [ "$res" != "" ];then
                #echo "Test present in List and not in Evo " $output
                a=""
        else
                echo " " $output
        fi
      
done
}
echo "Regression Test not in compile List "
grep " T " temp.findMissing |awk '{print $3}' | while read output;
do
    echo "Test Id  = " $output 
    testName=$(evo test list -id=$output -verbose | grep "^Name" | awk '{print $3}')
    echo testName 
    res=$(grep $testName agsL2IgrList)
    if [ "$res" != "" ];then
            a=""
    else
            echo $testName 
    fi
done

