cp /users/mthakare/fdx/Makefile .
cp ../../common/Makefile.inc ./mfileOring.man
sed 's/--e \.\/simv/--e \.\.\/simv/1' ../../common/Makefile.inc > mfileBkp.man && cp -f mfileBkp.man ../../common/Makefile.inc
make run test=$1 rargs=+vpd debugLvl=DEBUG 
mv mfileOring.man ../../common/Makefile.inc
pwd | mail -s "Work done " mthakare
