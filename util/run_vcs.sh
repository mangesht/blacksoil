#!/usr/bin/sh
seed=$RANDOM
vcs --e simv +vcs+lic+wait -cm line+branch+cond+fsm -cm_name $1   +ntb_random_seed=$seed +ntb_exit_on_error=100 +vmm_log_nofatal_at_1000 +usrNoIcgPerc=100 +test=$1  $2 |  tee $1.log 
~/util/log_format.pl $1.log
mkdir ../$1 
cp *.vpd ../$1/
cp local.log ../$1/

