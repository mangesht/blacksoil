#!/usr/bin/sh
seed=$RANDOM
#testName=$1
testName='agsL2EccParityAttribute2B'
vcs --e simv +vcs+lic+wait +vcs+initreg+random -cm line+branch+cond+fsm -cm_name $testName   +ntb_random_seed=$seed +ntb_exit_on_error=100 +test=$testName  +memNameArg=$1 +testNameArg=memGsbuParityTest1WHw |  tee $testName.log 
~/util/log_format.pl $testName.log
mkdir ../$testName$1 
cp *.vpd ../$testName$1/
cp local.log ../$testName$1/

