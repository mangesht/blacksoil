#!/router/bin/perl
use strict;
my $tempFileName = "/users/mthakare/tag_it.tmp";
my $line;
my $word;
my $workingRevision;
my $cvsFileName; 
my $tagFileName;
my $tagListName = "/users/mthakare/util/tags/tagList";
my @errorLog;
if(!open(TAGLIST,'<',$tagListName)){
    print  "Die Could not open $tagListName for reading \n";
}else {
        while($line =<TAGLIST>){
                chomp($line);
          $word = $line ;   
          #print "Word = $word\n";
        }
}
close TAGLIST;
chop($word);
#print " Word = $word";
$_ = $word;
$word =~ s/ //g;
/\w[a-zA-Z0-9]*$/;
$word = $&;
#print "Word = $word";
$word =~ s/[a-zA-Z]*//g;
$word = $word +1 ; 
#print $word ;
#<STDIN>;
if(!open(TAGLIST,'>>',$tagListName)){
    die "Die Could not open $tagListName for writing \n";
}
$tagFileName = "/users/mthakare/util/tags/tag$word";
print "Creating Tag in $tagFileName \n";
my $t = localtime();
print TAGLIST "$t $tagFileName \n";
close TAGLIST;
system('cvs stat | grep File: -A 3 > ~/tag_it.tmp');

if(!open(FILELIST,"<$tempFileName")){
    die "Die Could not open $tempFileName for reading \n";
}


if(!open(TAGFILE,'>',$tagFileName)){
    die "Die Could not open $tagFileName for writing \n";
}
while($line=<FILELIST>){
        chomp($line);
        $_ = $line;
        if (/^File:/){
## Sample Search File: upsAgsIgrL3CtsTest.sv     Status: Up-to-date
                my $status;
                $status = $line;
                $status = ~/Status: .*/;
                $status = $&;
                $status =~ s/Status: //g;

                $line =~ /^File:.*Status/;
                $line = $&;
                $line =~ s/^File: *//g;
                $line =~ s/Status$//g;
                $cvsFileName = $line;
                $_ = $status;
                if(/Up-to-date/){
                }else{
                        #@errorLog.push ($cvsFileName) ;
                    $errorLog[++$#errorLog] = $cvsFileName ;
                }
        }elsif(/Working revision:/){
##        Working revision:    1.3     Fri Apr 30 14:20:58 2010
          $line =~ s/Working revision: *//g;
          $line =~ s/://g;
          $line =~ s/  *\W//g;
          $line =~s/  *\w\w*//g;
          $line =~ s/[a-zA-Z]*//g;
          $workingRevision = $line ;
          #print "Working Num = $workingRevision \n";
        }elsif(/Repository revision/){
##      Repository revision: 1.3     /nfs/gsg-asic/cvsroot/argus/dv/sv/tests/ags/upsAgsIgrL3CtsTest.sv,v
            $line =~ /\/nfs.*,/;
            $line = $& ;
            $line =~ s/\/nfs.*cvsroot\///g;
            $line =~s/,//g;
            $cvsFileName = $line ; 
            print TAGFILE "$cvsFileName $workingRevision\n"

        }
}
print "\n\nCreated Tag in $tagFileName \n";
print "\nFollowing files are modified \n\n";
foreach my $file(@errorLog) {
        print "$file \n";
}
#print "@errorLog\n";
print "\n";
close FILELIST;
close TAGFILE;
