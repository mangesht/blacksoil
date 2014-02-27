#include<stdio.h>
#include<stdlib.h>
#include<string.h>
void add_student();
void fill_info();
void display_list();
//void push();
void newdata();
typedef struct student
{
 char name[256];
 int roll_no;
 int marks;
 struct student *nextnode;

}student;
student *startnode;
int len;

 void main()
{
    int i;
    for(i=0;i<10;i++) {
         len++; 
        add_student();
                      }      
    display_list();
    //printf("%d",len);
    printf("\n Entering new node in thr list");
  //  push();
    display_list();
    //printf("%d",len);
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
  student *current;
  current=startnode;
printf("\n Total number of nodes are: %d",len);
  if(current==NULL) {
            printf("List is empty\n");
            return ;           }
else{
  while(current!=NULL) {
 printf("\nname = %s %d %d \n",current->name,current->roll_no,current->marks);
        current=current->nextnode;
    }

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
/*void push()
{

student *temp;
student *newnode;
student *cur;
 newnode=(student*)malloc(sizeof(student));

 cur=startnode->nextnode;
cur->nextnode=startnode->nextnode->nextnode; 
 temp=cur->nextnode;
 cur->nextnode=newnode;
 newnode->nextnode=temp;
len++;
 printf("name = %s %d %d \n",newnode->name,newnode->roll_no,newnode->marks);

 newdata(newnode);
} 

void newdata(student *newnode){
if(newnode==NULL){
printf("\n nothing in new node");
                  return;}     
else {
    strcpy(newnode->name,"sonu");
    newnode->roll_no=random() % 1000;
    newnode->marks=random() % 10;
      }
}*/
                                                                                                    
