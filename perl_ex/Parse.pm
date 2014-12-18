#!/usr/local/bin/perl
use strict;

package Parse;
my @id_list;
my $file_to_parse;
my $name;

#my $fh;
sub new{
    print "New called with @_\n";
    my $fh;
    my ($class)  =shift;
    my $self = {
        file_to_parse =>shift,
        fh => "",
        name => "",
        nocomments=>0
    };
    # nocomments = 0 -> token is returned as is without checking for comments
    # nocomments = 1 -> commented portion is not sent to user, it is dropped
    $file_to_parse = $self->{file_to_parse};
    if(!open($fh,$file_to_parse)){
        die "Can't read  $file_to_parse file \n";
    }else{
        print "File $file_to_parse opened fh=$fh\n";
    }
    $self->{fh} = $fh;
    bless $self,$class;
    return $self;
}
sub DESTROY{
    my ($self) = @_;
    my $fh = $self->{fh};
    print "destroying fh\n";
    close $fh;
}
sub get_rest_of_the_line(){
    my ($self) = @_;
    my $token;
    my $k;
    while(@id_list>0){
        $token = $token ." ". shift @id_list;
    }
    return $token;
}
sub get_line(){
    my ($self) = @_;
    my $fh = $self->{fh};
    my $line;
    if($line=<$fh>){
        #print "Reading $line\n";
        return $line;
    }else{
        #print "Reading $line\n";
        return "__EOFPARSE";
        
    }
}
sub get_token(){
    my ($self) = @_;
    my $token ;
    my $exit_loop = 0;
    #print "get_token called \n";
    do{
        #print "doing \n";
        $token = $self->get_token_c();
        if($self->{nocomments} == 1){
            #print "Nocomments \n";
            if (($token cmp "//") == 0 ){
                $token = $self->get_rest_of_the_line();
            }elsif(($token cmp "/*") == 0) {
                do{
                    $token = $self->get_token_c();
                }while($token cmp "*/");
            }else{
                $exit_loop = 1;
            }
        }else{
            #print "Yescomments \n";
            $exit_loop = 1;
        }
    }while($exit_loop == 0);
    #print "Returning --$token--\n";
    return $token;
}
# gets token with comments 
sub get_token_c(){
    my ($self) = @_;
    my $token;
    my $line;
    my $eof = 0 ;
    my $id=@id_list ; 
    my $fh = $self->{fh};
    #print "1 @id_list\nid=$id";
    while((@id_list<= 0) and ($eof == 0) ) {
        #print "2\n";
        $line = $self->get_line();
        #print "Getline returns $line\n";
        if($line cmp "__EOFPARSE"){
            @id_list= $self->get_identifier($line);
            $eof = 0 ;
        }else{
            #print "3\n";
            # End of File
            $eof = 1 ;
        }
    }
    if($eof==0) {
        $token = shift @id_list;
        #print "From there\t";
    }else{
        #print "From here\t";
        $token = "__EOFPARSE";
    }
    return $token;
}
sub get_block{

# This function starts with opening bracket / indentifier and concates all the tokens till corresponding end of bracket / identifier is encountered 
# It is assumed that the function is called when you already encountered opening indentifier. So the count starts with 1 here 

my ($self) = shift @_;
my $opening = shift @_; 
my $closing = shift @_; 

my $cnt = 1;
my $blk;
my $token;
my $comment_status = $self->{nocomments};
while($cnt > 0 ) {
    $token = $self->get_token();
    if(($token cmp $opening ) == 0 ) {
        $cnt++;
    }elsif(($token cmp $closing) == 0) {
        $cnt--;
    }
    $blk = $blk . " " . $token ;
}

$self->{nocomments} = $comment_status;
return $blk;
}
sub get_identifier(@){
my ($self) = shift @_;
my $inputLine = shift @_; 
my @chars;
my $char;
my $id = "";
my $id_index = 0;
my $len;
my @id_list;
my $started_collecting;
#print "get_identifier inline $inputLine \n";
#print "Analysing $inputLine \n";
    @chars = split(//,$inputLine);
    $len = $#chars;
    #print "Lenght of string to be analyzed = $len \n";
    for(my $i=0;$i<$len;$i++){
            #print " $chars[$i]";
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
                 if(($chars[$i] =~ /[+-=\*\/]/) and ($chars[$i+1] =~ /[+-=\*\/]/)){
                    $id=$chars[$i];
                    $i++;
                    $id = $id . $chars[$i];
                    $id_list[$id_index++] = $id;
                    #print "Double Operator $id\n";
                    # Check if next is also operator of same kind 
                    #if($chars[$i+1] =~ /[+-=\*\/]/){
                    #    print "Operator $chars[$i]$chars[$i+1]\n";
                    #}
                 }else{
                    #print "Single Operator $chars[$i]\n";
                    $id=$chars[$i];
                    $id_list[$id_index++] = $id;
                }
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
1;

