#!/usr/bin/sh

cvs up /auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/attrList.txt

grep ""  /auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/attrList.txt | while read output;
do
    echo $output
    cvs up /auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/$output
done 

/auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/attr_to_csv.pl 0 /auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/attrList.txt 0 
/auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/attr_to_csv.pl 0 /auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/attrList.txt 1 
cp -f /auto/gsg-dump5/mthakare/attr/argus/dv/doc/attributes/*.csv /users/mthakare/util/attr_to_csv
