#!/bin/sh
#man=$(find ./ -name \*.\*)
find_str=num_channels
r_str=MISANO
#man=$(grep -l $find_str *)
man=$(find ./ -name \*.rules | xargs grep $find_str -l ) 
dest_chan=0
dest_flow=0
max_flow=29
max_chan=10
dest_flow_1=0
dest_chan_1=0
for f in $man
do 
    echo Processing $f
#    sed "s/tb\.intf\.AN_BNG_HIT\[\*\]/tb\.intf\.channel\[\*\]\.flow\[\*\]/g" $f > abc.txt && mv abc.txt $f
      # Following row replaces the matched string 
  #     sed "s/$find_str/$r_str/g" $f > abc.txt && mv abc.txt $f
      # Following row deletes the matched string 
#     grep -v $find_str $f > abc.txt && mv abc.txt $f 
        
      num_chan=$(grep $find_str $f | awk '{print $3}')
      num_flow=$(grep "num_flows" $f | awk '{print $3 }')
      total_flows=`expr $num_chan \* $num_flow`
      echo "Num chan " $num_chan 
      echo "Num flows " $num_flow
      echo "Total flows " $total_flows
      dest_chan=$num_chan
      dest_flow=$num_flow
      if [ $num_chan -ge $max_chan ]; then
            echo "num chan ge than 9 " 
            dest_chan=9
      fi
      dest_flow_1=`expr $total_flows / $dest_chan`

      dest_flow=$dest_flow_1

      if [ $dest_flow_1 -ge $max_flow ]; then 
            dest_flow=28
            dest_chan_1=`expr $total_flows / $dest_flow`
            dest_chan=$dest_chan_1
      fi 

      if [ $dest_chan -ge $max_chan ]; then
            echo "num chan ge than 9 " 
            dest_chan=9
      fi
     
      
      if [ $total_flows -ge 252 ]; then 
            dest_chan=9
            dest_flow=28
      fi 
      sed "s/num_channels *= *$num_chan/num_channels = $dest_chan/g" $f >abc.txt && mv  -f abc.txt $f
      sed "s/num_flows *= *$num_flow/num_flows = $dest_flow/g" $f >abc.txt && mv -f abc.txt $f 
done
