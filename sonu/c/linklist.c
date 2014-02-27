#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void add_student();
void fill_info();
void display_list();

typedef struct student
{
 char name[160];
 int roll_no;
 int marks;
 struct student *nextnode;
}student;
student *startnode;

 void main()
{
    int i;
    for(i=0;i<10;i++) { 
        add_student();
    }
    display_list();
}

void add_student()
{
student *node;
student *current;
node=(student*)malloc(sizeof(student));
node->nextnode==NULL;
fill_info(node);
    if(startnode==NULL){
        startnode=node;
        current=node;
        printf("\n there is no other node. this first");
    } else {
        printf("\n There r othr nodes too\n");
        // Get to tail node 
        // then append this node to tail
        current = startnode ;
        while(current->nextnode!=NULL){
            current = current->nextnode;
         }
         current->nextnode = node;
   }
}

 void display_list() { 
  current=startnode;
  while(current!=NULL) {
        printf("name = %s %d %d \n",current->name,current->roll_no,current->marks);
        current=current->nextnode;
  }
}

void fill_info(student *node)
{
if(node==NULL) return; 

else {
    strcpy(node->name,"nivedeeta");
    node->roll_no=random() % 1000;
    node->marks=random() % 100;
      }
}
