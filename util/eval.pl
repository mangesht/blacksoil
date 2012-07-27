#!/usr/local/bin/perl
use strict;
my $file_to_parse ="prob.txt";
if(scalar @ARGV > 0 ) { 
    $file_to_parse = shift @ARGV;
}

if(!open(MYINFILE,$file_to_parse))
{
    die "Can't read  $file_to_parse file \n";
}
my @stack;
my $s_start=0; # Point to location where first id is put 
my $s_end=0; # Points to location where new id ll go 
my $line;
my $operand_needed = 0 ; 
my $operand_needed_locn = 0 ; 
my $fin_ans;
foreach $line(<MYINFILE>){
my @ids;

#    print "parsing $line";
    @ids = &get_identifier($line);
    if ($#ids>2) { 
        $s_start = 0 ; 
        $s_end = 0 ; 
        foreach my $id(@ids){
                #print "$id ";
            &update($id);
            #print @stack;
            #print "\nstack_end $s_end Op Needed = $operand_needed op Loc = $operand_needed_locn \n"
        }
        $fin_ans= &evaluate();
        print "\n And the answer is $fin_ans \n";
    }

} 
print "\n";
sub evaluate(){
    my $ans=0;
    my $found=0;
    print "Evaluation started \n";
    while($s_end - $s_start > 1) { 
          my $cur = $s_start;
          while($cur < $s_end - 2 ){ 
            if(&is_operator($stack[$cur]) == 0 && &is_operator($stack[$cur+1]) == 0 && &is_operator($stack[$cur+2]) == 1) { 
            # Found operand operator triplet
            $found=1;
            last;
          }else{
            $cur++;
          }
       }
       if($found == 1 ){
           $ans = &calc($cur);
           # Putback the results 
           $stack[$cur] = $ans;
           #print "Updating $cur with $ans ";
           for(my $i = $cur +1 ; $i <$s_end-2 ; $i++){
                 $stack[$i] = $stack[$i+2]; 
           }
           $s_end =$s_end -2 ; 
       }else { 
               print "ERROR : Triplet not found \n"
       } 
       #print "\ns_start = $s_start s_end = $s_end Eval @stack "; 
    }
    return $stack[$s_start]; 
}
sub update(@){
    my $insLocn;
    my $id = shift @_;
    $insLocn = $s_end;
    if(&is_operator($id)){
        for(my $i=$s_end-1;$i>=$s_start;$i--){
             $operand_needed = 1 ;
             $operand_needed_locn = $i+1 ;
             $insLocn = $i+1;
             if(&is_operator($stack[$i])){ 
                  if(&is_higher($id,$stack[$i])){
                      # $id has higher prece than stack . Go on
                  } else {
                      # Stop here
                      last;
                  }
             }else{
                # Non operator Variable
                $operand_needed = 1 ;
                $operand_needed_locn = $i+1 ;
                last;
             }
        }
    }else{
        # This is an operand
        if($operand_needed == 1 ) {
              $insLocn = $operand_needed_locn;
              $operand_needed = 0 ; 
        } else{
              $insLocn = $s_end;
        }
    }
    &insert($id,$insLocn);
}
sub insert(@){
    #(id,insLocn)
    my $id = shift @_;
    my $insertLocn = shift @_;
    #print "Ins : id = $id Locn = $insertLocn ";
    for(my $i=$s_end-1;$i>=$insertLocn;$i--){
          $stack[$i+1] = $stack[$i];
    }
    $stack[$insertLocn] = $id;
    $s_end++;
    return;
}

sub is_operator(@){
    my $id = shift @_; 
    if(($id eq "*") || ($id eq "+") || ($id eq "/") || ($id eq "-")  ){ 
        return 1;
    } else {return 0;} 
}

sub is_higher(@){
my $id1 = shift @_;
my $id2 = shift @_;
# Returns 1 if id1 has higher precedance than id2 
    if(($id1 eq "+") || ($id1 eq "-")) { 
        return 0;
    }elsif($id1 eq "*" || $id1 eq "/" ) { 
        if(($id2 eq "+") || ($id2 eq "-")) { 
            return 1;
        } else { 
            return 0;
        }
    }
}

sub calc(@){
    my $cur = shift @_; 
    my $op1 = $stack[$cur];
    my $op2 = $stack[$cur+1];
    my $operator = $stack[$cur+2];
    if($operator eq "+") { 
            return ($op1 + $op2);
    }elsif($operator eq "-") { 
            return ($op1 - $op2);
    }elsif($operator eq "*") { 
            return ($op1 * $op2);
    }elsif($operator eq "/") { 
            return ($op1 / $op2);
    }
}

sub get_identifier(@){
my $inputLine = shift @_; 
my @chars;
my $char;
my $id = "";
my $id_index = 0;
my $len;
my @id_list;
my $started_collecting;
#    print "Analysing $inputLine \n";
    @chars = split(//,$inputLine);
    $len = $#chars;
#    print "Lenght of string to be analyzed = $len \n";
    for(my $i=0;$i<$len;$i++){
#        print " $chars[$i]";
        if($chars[$i]=~ /\w/){
                #print "Word";
             $started_collecting = 1 ; 
             $id = $id . $chars[$i];
        }else{
                #print "\n Id = $id \n";
            if($started_collecting == 1 ) { 
                $id_list[$id_index++] = $id;
            } 
            $started_collecting = 0 ;
            # For puntuations and operators
            if(($chars[$i]=~ / /) || ($chars[$i]=~ /\t/)) { 
                # This is spaces / non printable chars
                #print $id ;
                #print "Space -$id- char -$chars[$i]-\n"
            }else{
                 # This is puntuations and operators
                 $id=$chars[$i];
                $id_list[$id_index++] = $id;
                #print "\n Spl Id = $id \n";
            }
            $id="";
        }
    }
    if($id ne ""){
        $id_list[$id_index++] = $id;
    }
    return @id_list;
}
