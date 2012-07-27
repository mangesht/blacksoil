#!/usr/bin/sh
base_dir="/auto/gsg-dump5/mthakare/argus_regression"
argus_dir=$(echo "argus"$(date|sed -e "s/:/ /g" | awk '{print $2$3"_"$4"_"$5}'))
#cd $base_dir
argus_dir="argusJun15_00_04"
#mkdir $argus_dir
echo "Making Directory " $argus_dir 
#cd $argus_dir
#echo "Checking out Argus  "
#bsub evo checkout -proj=argus argus 
#~/util/wait_evo_checkout.sh mthakare
cd "argus"
evo build -id=7 -grid 
~/util/jobDone.sh mthakare
evo regr run -id=26 -grid 
~/util/jobDone.sh mthakare
