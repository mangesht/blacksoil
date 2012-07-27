#!/router/bin/perl

chdir("/auto/gsg-dump5/mthakare/ecc7June/argus/");
my $res=system("/auto/gsg-users/vkadamby/mlt/evo_ags/bin/evo test list -id=200 > pre.txt");
print "$res\n";
