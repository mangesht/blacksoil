#!/usr/bin/sh

echo "Mangesh "
ls | while read output;
do
    echo -e "Searching dir "$output
    ls $output/argus/dv/sv/tests/ags | grep -i Auth 
done 
