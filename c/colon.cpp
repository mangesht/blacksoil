#include<iostream>
using namespace std;

class abc {
        public : 
                abc(int i) : myValue(i)
        {};
                void printVal(void){
                        cout << "Mangesh \n",  myValue, "\n";
                        cout << myValue;
                        cout <<"\n";
                }
        private : 
                int myValue;
};
int main (){
        abc a(10);
        a.printVal();
        return 0;
}

