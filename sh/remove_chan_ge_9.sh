#!/bin/sh
#man=$(find ./ -name \*.\*)
find_str="channel\[[123456789][0123456789]"
r_str=MISANO
#man=$(grep -l $find_str *)
man=$(find ./ -name \*.rules)
echo $find_str
for f in $man
do 
    echo $f
#    sed "s/tb\.intf\.AN_BNG_HIT\[\*\]/tb\.intf\.channel\[\*\]\.flow\[\*\]/g" $f > abc.txt && mv abc.txt $f
      # Following row replaces the matched string 
      # sed "s/$find_str/$r_str/g" $f > abc.txt && mv abc.txt $f
      #Following row deletes the matched string 
      grep -v $find_str $f > abc.txt && mv abc.txt $f 
done
