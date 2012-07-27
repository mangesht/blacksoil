dir_name=$(date| awk '{print $4}')
dir_name=$(echo "argus_"$dir_name)
echo $dir_name
#rm -fr "argus" 
#evo checkout -proj=argus argus
evo checkout -proj=argus $dir_name
cd "/auto/gsg-dump6/mthakare/hourly_rel"
#cd "argus"
cd $dir_name
echo "PWD"
echo "Updating to cvs tot"
echo "Updating to cvs tot"
echo "Updating to cvs Design"
cvs up "design"
echo "Updating to cvs DV"
cvs up "dv"
pwd
echo " "
evo release -m "Hourly release" -proj=argus -skip_open=1
#pwd | mail -s "Evo release fired " mthakare

