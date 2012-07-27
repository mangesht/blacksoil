
argus=argus
day=21
man=$(echo $argus$day)
echo "Man" $man
argus_dir=$(echo "argus"$(date |awk '{print $2$3}' ))
echo $argus_dir
