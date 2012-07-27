#!/usr/bin/sh
toFind="^ *channelIds"
replaceWith="       \/\/channelIds"

echo $toFind
echo $replaceWith
man=$(find ./ -name \Makefile | xargs grep "skipNbyte" -l)
for files in $man
do
        echo $man
        # Folllowing row replaces the matched string 
        sed "s/$toFind/$replaceWith/g" $files > abc.txt && mv abc.txt $files
done
