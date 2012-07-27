#!/usr/bin/sh

while [ 1 ] 
do
cd /auto/gsg-dump6/mthakare/argus_regression/dhl_ingress
argus_dir=$(echo "argus"$(date|sed -e "s/:/ /g" | awk '{print $2$3"_"$4"_"$5}'))
#argus_dir="/auto/gsg-dump5/mthakare/ecc7June/argus/"
echo $argus_dir $(date) >> /users/mthakare/cron.log
evo checkout -proj=argus $argus_dir
cd $argus_dir
#/auto/gsg-users/vkadamby/mlt/evo_ags/bin/evo test list -id=200 >pre.txt
evo build -id=7 -grid 
sleep 6 
/users/mthakare/util/jobDone.sh
evo regr run -id=26 -grid 
evo regr run -id=32 -grid 
evo regr run -id=37 -grid 
# Start Egress Regression 
cd /auto/gsg-dump6/mthakare/argus_regression/dhl_egress
argus_dir=$(echo "argus"$(date|sed -e "s/:/ /g" | awk '{print $2$3"_"$4"_"$5}'))
#argus_dir="/auto/gsg-dump5/mthakare/ecc7June/argus/"
echo $argus_dir $(date) >> /users/mthakare/cron.log
evo checkout -proj=argus $argus_dir
cd $argus_dir
#/auto/gsg-users/vkadamby/mlt/evo_ags/bin/evo test list -id=200 >pre.txt
evo build -id=6 -grid 
sleep 6 
/users/mthakare/util/jobDone.sh

evo regr run -id=34 -grid 
evo regr run -id=48 -grid 
curDir=$(pwd)
echo $curDir
echo $curDir | mail -s " Argus Regression started " mthakare
echo "Waiting for next time "
sleep 2d
done

