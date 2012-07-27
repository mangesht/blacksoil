#!/usr/bin/sh
testName=$(evo test list -id=$1 | grep "Name" | awk '{print $3}')
testName=$(echo $testName".sv")
owner=$(cvs log $testName | grep "revision 1.1" -A 1 | grep "author" | awk '{print $5}')
echo $testName $owner 
