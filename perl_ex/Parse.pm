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
        name => ""
    };
    $file_to_parse = $self->{file_to_parse};
    if(!open($fh,$file_to_parse)){
        die "Can't read  $file_to_parse file \n";
    }
    $self->{fh} = $fh;
    bless $self,$class;
    return $self;
}
sub DESTROY{
    my ($self) = @_;
    my $fh = $self->{fh};
    close $fh;
}
sub get_line(){
    my ($self) = @_;
    my $fh = $self->{fh};
    my $line;
    if($line=<$fh>){
        return $line;
    }else{
        return "__EOFPARSE";
    }
}
sub get_token(){
    my ($self) = @_;
    my $token;
    my $line;
    my $eof = 0 ;
    my $id=@id_list ; 
    my $fh = $self->{fh};
    #print "1 @id_list\nid=$id";
    while((@id_list<= 0) and ($eof == 0) ) {
        #print "2\n";
        $line = get_line();
        if($line cmp "__EOFPARSE"){
            #print "3\n";
            # End of File
            $eof = 1 ;
        }else{
            @id_list= get_identifier($line);
        }
    }
    if($eof==0) {
        $token = shift @id_list;
    }else{
        $token = "__EOFPARSE";
    }
    return $token;
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
1;

