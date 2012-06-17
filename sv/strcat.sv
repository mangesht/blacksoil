
class aClass ;
	rand int a ; 
   constraint aCnstr {  
     a > 10 ; 
   }
endclass 

program first();
int a ;

initial begin
aClass b;
string moduleNameUcFirst;
string moduleName = "ipp";
string sub;
string m = "Mangesh";
string n = "Thakare";
string intStat ="agsL2IluInterruptStatus";
bit[7:0] byteStr[];
string str;
string strTemp;
int l; 
int j;

string o = {m , n };

    moduleNameUcFirst = moduleName;
    sub = moduleName.substr(0,1);
    moduleNameUcFirst.putc(0,sub.toupper());
    $display("Sub = %s \n",sub);
    $display("moduleNameUcFirst = %s \n",moduleNameUcFirst);
    l = intStat.len();
    moduleName = intStat.substr(0,l-15-1);
    $display("Module Name = %h \n",moduleName);

$display("O = %s \n",o);
str="";
 byteStr = new[5]('{8'h11, 8'h00 ,8'h12 ,8'h00 ,8'h13});
 foreach(byteStr[i]) begin 
         str = {str,string'(byteStr[i])};
 end

    $display("String = %h \n",str);
    strTemp = "25"; 
    j = strTemp.atoi();
 foreach(byteStr[i]) begin 
    strTemp = "";
    str = "Mangesh[";
    strTemp.itoa(i);
    str = {str,strTemp};
    $display("String = %s \n",str);
 end



end 
endprogram

