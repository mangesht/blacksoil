#!/usr/bin/sh
cvs stat $1 | grep "Working" | awk '{print $1 " " $2 " " $3 }'
echo "CVS " $(cvs log $1 | grep -e "^head:")
