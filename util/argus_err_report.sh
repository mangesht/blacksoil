find ./ -name \*test.log | xargs /bin/grep -m 1 -i mError  | grep -v '\-\-' | sed -e "s/  .*sv\/env\/ags/ PATH/g" | sed -e "s/,//g" | sed -e "s/:/,/1" | sed -e "s/\.log-/&,/1" |sed -e "s/\.log-/\.log/1"
#find ./ -name \*test.log | xargs /bin/grep -m 1 -i mError -A 1 | grep -e "FAILURE" -v | grep -v '\-\-' | sed -e "s/  .*sv\/env\/ags/ PATH/g" | sed -e "s/,//g" | sed -e "s/:/,/1" | sed -e "s/\.log-/&,/1" |sed -e "s/\.log-/\.log/1"
