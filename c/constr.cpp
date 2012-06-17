#include<iostream>
using namespace std;


class Abc {
        public : 
    Abc(){
            cout << "Default constrtor\n "; } ;
    Abc(int a) { cout << "In A \n" ; }; 

};

int main (){
Abc abc(10) ; 
//abc = new ();
return 0;
}
