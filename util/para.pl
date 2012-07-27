#!/usr/bin/perl

chdir("/auto/gsg-users1/mthakare");

exec ("evo checkout -proj=argus argus");
exec ("evo regr run -id=11");

