#include <iostream>
using namespace std;

void &my_print(){
 cout <<  "Mangesh \n";
}

int main (){
void *ptr ;

ptr = my_print();
printf("Address of my_print = %x \n",a);

//ptr();
return 0;
}
