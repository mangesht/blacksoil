#!/usr/bin/perl

use strict;
use Switch;

my $infile = "prog.ini";
my $outfile = "code.hex";

if(@ARGV > 1) {
        $infile = shift @ARGV ;
        $outfile = shift @ARGV;
}elsif(@ARGV > 0 ) {
        $infile = shift @ARGV ;
}

if(!open(FILEIN,"<$infile")){
        die "Could not open $infile \n";
}

if(!open(FILEOUT,">$outfile")){
        die "Could not open $outfile \n";
}

while(<FILEIN>){
    my $line = $_; 
    $line =~ s/^ *//g;
    my @words;
    my $var;
    my $keyword;
    my $param1;
    my $param2;
    my $param3;
    my $code = 0;
    print "Processing \n$line \n";
    @words = split(/([, ])/,$line);
    foreach $var (@words){
            #print "Var = $var \n";

    }
    $keyword = shift @words ;
    #print "keyword = $keyword \n";
    if($keyword eq "sll" || $keyword eq "srl" || $keyword eq "add" || $keyword eq "sub" || $keyword eq "and" || $keyword eq "xnor"){
        $var = shift @words ; 
        while($var eq " " || $var eq ","){
                $var = shift @words ; 
        }
        $param1 = $var; 
        $var = shift @words ; 
        while($var eq " " || $var eq ","){
                $var = shift @words ; 
        }
        $param2 = $var; 
        
        $var = shift @words ; 
        while($var eq " " || $var eq ","){
                $var = shift @words ; 
        }
        $param3 = $var; 
        #print "Command = $keyword $param1 $param2 $param3 \n";
        if($keyword eq "sll") { 
            $code = 0 ;
        }elsif($keyword eq "srl"){
            $code = 1 ; 
        }elsif($keyword eq "add"){
            $code = 2 ; 
        }elsif($keyword eq "sub"){
            $code = 3 ; 
        }elsif($keyword eq "and"){
            $code = 4 ; 
        }elsif($keyword eq "xnor"){
            $code = 5 ; 
        }
        $param1 =~ s/@//g;
        $var = abs($param1) + 0 ; 
        $code = $code * 16 + $var; 
        #print "Command = var $keyword $code $var\n";
        $param2 =~ s/@//g;
        $var = abs($param2) + 0 ; 
        $code = $code * 16 + $var; 
        $param3 =~ s/@//g;
        $var = abs($param3) + 0 ; 
        $code = $code * 16 + $var; 
        printf("Command = $keyword $code = %04x \n",$code);
        printf(FILEOUT " %04x\n",$code);
    }elsif($keyword eq "loadi"){ 
        $var = shift @words ; 
        while($var eq " " || $var eq ","){
                $var = shift @words ; 
        }
        $param1 = $var; 
        $var = shift @words ; 
        while($var eq " " || $var eq ","){
                $var = shift @words ; 
        }
        $param2 = $var;
        #printf "param2 = $param2 \n";
        if($keyword eq "loadi") {
            $code = 10 ; 
        }
        $param1 =~ s/@//g;
        $var = abs($param1) + 0 ; 
        $code = $code * 16 + $var;

        $code = $code * 256 + $param2;
        printf("Command = $keyword $code = %04x \n",$code);
        printf(FILEOUT " %04x\n",$code);
    }elsif ($keyword eq "jz" ||$keyword eq "jnz" || $keyword eq "jnc" || $keyword eq "jc"){
              $var = shift @words ; 
        while($var eq " " || $var eq ","){
                $var = shift @words ; 
        }
        $param1 = $var;
        if($keyword eq "jnc" || $keyword eq "jc"){
                $param2 = $param1 ;
                $param1 = 0 ; 
        }else{
                $var = shift @words ; 
                while($var eq " " || $var eq ","){
                        $var = shift @words ; 
                }
                $param2 = $var;
        }
        #printf "param2 = $param2 \n";
        if($keyword eq "jz"){
            $code = 8 ; 
        }elsif($keyword eq "jnz"){
            $code = 9 ;
        }elsif($keyword eq "jnc"){
            $code = 11 ;
        }elsif($keyword eq "jc"){
            $code = 12 ;
        }
        $param1 =~ s/@//g;
        $var = abs($param2) + 0 ; 
        my $var1 = $var << 4 ; 
        printf("var = %x Var1 = %x \n",$var,$var1);
        $param2 = ($var | $var1) & 0xf0f; 
        $param1 = $param1 << 4 ;
        $var = $param1 + $param2;
        printf("OR var = %x Var1 = %x \n",$var,$var1);
        $code = ($code << 12 ) + $var;

        ##$code = $code * 256 + $param2;
        printf("Command = $keyword $code = %04x \n",$code);
        printf(FILEOUT " %04x\n",$code);

    }elsif($keyword eq "stop"){
         $code = 0xffff;
         printf("Command = $keyword $code = %04x \n",$code);
        printf(FILEOUT " %04x\n",$code);
    }
}

sub getNext {
        my $temp = shift @_;
        print "Got @_ \n";
        while($temp eq " " || $temp eq "," || $#_ lt 1){
                $temp = shift @_;
        }
        print "Returning $temp \n";
        return $temp;
}

sub getRegNum {
        my $temp = shift @_;
        switch ($temp){
                case '@a' { return 0; } 
                case '@b' { return 0; } 
                case '@c' { return 0; } 
                case '@d' { return 0; } 
                case '@e' { return 0; } 
                case '@f' { return 0; } 
                case '@g' { return 0; } 
                case '@h' { return 0; } 
                else {return 15;}
        }
}
