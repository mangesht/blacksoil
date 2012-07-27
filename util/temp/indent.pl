#!/usr/local/bin/perl
#system('find ./ -name \*.e >dir_list.mat' );
my $list_of_files = "ThereIsNoFile";
if(scalar @ARGV>0){
    $list_of_files = shift @ARGV;
}
print "Listing $list_of_files \n";
system('\rm -f dir_list.mat'); 
system("ls  $list_of_files >dir_list.mat"); 


if(!open(MYINFILE,"dir_list.mat"))
{
    die "Can't read Dir List  file \n";
}

foreach $open_file(<MYINFILE>)
{
    
    if(!open(MYFILE,$open_file))
    {
        die "Can't read temp.txt file \n";
    }
    else 
    {
        print "File Processing ...$open_file " ; 
    };
    
    if (!open(OUTFILE,">indent_it.mat"))
    {
        die "Can't read temp.txt file \n";
    }
    
    my $brace_count ; 
    $brace_count = 0 ; 
    
    foreach $strn(<MYFILE>)
    {
        ##  print $strn ;
        
        @words = split(//,$strn);
        #    $my_word = $&; 
        #    $my_word =~ s/[;.,:-]$//;
        #    print $my_word ; 
        @words = &trim(@words);
        #    for($i=0;$i< ($brace_count * 4); $i++ ) {
            #        print " "; 
        #    }
        $incr_val = 0 ; 
        $close_brace_first = 0 ; 
        $open_brace_first = 0 ; 
        foreach $word (@words)
        {
            #        print $word ;
            #        print "  "; 
            if ($word =~ /{/)
                {
                    #            print("Brace Found");
                    $incr_val++ ;
                    if ($close_brace_first == 0 ) 
                    {
                        $open_brace_first = 1 ; 
                    }
                };
            if ($word =~ /}/)
            {
                #            print("Brace Found");
                $incr_val-- ; 
                if ($open_brace_first == 0 ) 
                {
                    $close_brace_first = 1 ; 
                }
            };
        }
        #    print ("\n INCR VAL $incr_val"); 
        if ($incr_val > 0 )
        {
            for($i=0;$i< ($brace_count * 4); $i++ ) {
                print OUTFILE " "; 
            }
            print OUTFILE @words; 
            #        print ("\n $brace_count\n"); 
            $brace_count++; 
        }
        else 
        {
            if ($incr_val < 0 )
            {
                $brace_count--; 
                for($i=0;$i< ($brace_count * 4); $i++ ) {
                    print OUTFILE " "; 
                }
                print OUTFILE @words; 
                #            print ("\n $brace_count\n"); 
            }
            else {
                if ( $close_brace_first == 1 ) 
                {
                    $brace_count--; 
                }
                for($i=0;$i< ($brace_count * 4); $i++ ) {
                    print OUTFILE " "; 
                }
                print OUTFILE @words; 
                #            print ("\n $brace_count\n"); 
                if ( $close_brace_first == 1 ) 
                {
                    $brace_count++; 
                }
            };
        }
    }
    system ("mv indent_it.mat $open_file"); 
}

system('\rm -f dir_list.mat'); 

sub trim(@)
{
    my @string = @_ ; 
    #    print @string ; 
    #    @chars = split(//,@string); 
    $space_count    = 0 ; 
    foreach $cha (@string)
    {
        #        print " $cha $space_count " ; 
        if (($cha =~ / /)or ($cha =~ /\t/)) 
        { 
            #
            $space_count++;
            
        }
        else 
        {
            #            next; 
            goto NEXTLINE ; 
        }
    }
    NEXTLINE :    my @new_string; 
    my $len;
    my $i;
    #    print "\nBefore \n @string" ;
    #    print @string ; 
    $len = @string;
    #    print " Len = " ; 
    #    print $len ; 
    #    @string
    for ($i= $space_count;$i<$len;$i++)
    {
        $new_string[$i-$space_count] = $string[$i];
        #        print "i =  "; 
    }
    #    print "After \n" ;
    #    print @new_string ;
    return @new_string; 
    #    print ("\n No of spaces $space_count" );
}


