#!/usr/bin/sh
saveE=$EDITOR
EDITOR="/users/mthakare/util/evo_editor.sh"
toFind='agsL2IgrIrfFifoPtrRollOverTest'
replaceWith=$1
echo "Look at xterm , see the template"
xterm -e "evo test add -template=200" & 
#xterm -e "evo test edit -id=$1" & 
sleep 3
pid=$(ps -ef | grep evo_perl | grep test | awk '{print $2}')
filename=$(echo "/tmp/mthakare."$pid".test_new")
echo $filename  "Adding $replaceWith"
sed "s/$toFind/$replaceWith/g" $filename > abc.txt && mv -f abc.txt $filename
echo "Quit editing without saving . Close the xterm "
EDITOR=$saveE

