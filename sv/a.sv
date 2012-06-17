program test( bus_A.test a, bus_B.test b );
clocking cd1 @(posedge a.clk);
input a.data;
output a.write;
inout state = top.cpu.state;
endclocking
clocking cd2 @(posedge b.clk);
input #2 output #4ps b.cmd;
input b.enable;
endclocking
initial begin
// program begins here
...
// user can access cd1.a.data , cd2.b.cmd , etc…
end
endprogram


#define TEN 5+5


int c = TEN*TEN ; 
print("%d",c);
//100 ? Wrong 
// 5 + 5 * 5 + 5 = 10+ 25 = 35 Right  

int j = 10;
print("%d %d %d", ++j,++j,++j);

// output is ?
// 11 12 13 Wrong
// 11 11 11 Wrong


