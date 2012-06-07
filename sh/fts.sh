#!/bin/sh
#man=$(find ./ -name \*.\*)
find_str="SDBRULE\.sni_dei_src_sel"
r_str=MISANO
#man=$(grep -l $find_str *)
man=$(find ./ -name \VDiag.rules | xargs grep $find_str -l ) 
for f in $man
do 
    echo $f
#    sed "s/tb\.intf\.AN_BNG_HIT\[\*\]/tb\.intf\.channel\[\*\]\.flow\[\*\]/g" $f > abc.txt && mv abc.txt $f
      # Following row replaces the matched string 
#    sed "s/$find_str/$r_str/g" $f > abc.txt && mv abc.txt $f
      # Following row deletes the matched string 
     grep -v $find_str $f > abc.txt && mv -f abc.txt $f 
done
