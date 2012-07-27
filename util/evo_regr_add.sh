#!/usr/bin/sh
toFind="] *$"
replaceWith=$1
id=26
echo "Look at xterm , see the template"
rpw=$(echo ","$replaceWith":T]")
#xterm -e "evo test add -template=200" & 
xterm -e "evo regr edit -id=26" & 
sleep 5
pid=$(ps -ef | grep evo_perl | grep regr | awk '{print $2}')
filename=$(echo "/tmp/mthakare."$pid".regr_new")
#filename="/users/mthakare/util/temp/regrEdit.log"
echo $filename  "Adding $replaceWith"
sed "s/$toFind/$rpw/g" $filename > abc.txt && mv -f abc.txt $filename
echo "Quit editing without saving . Close the xterm Press Enter to continue"
name=""
read name
