int main()
{
    int arr[3] = {2, 3, 4};
    char *p;
    char c;
    int i;
    int *r;
    p = arr;
    p = (char*)((int*)(p));
    printf("%d, before p %x ", *p,p);
    p = (int*)(p+4);
    printf("%d after %x \n\n", *p,p);

    i = 5 ; 
    c = (char) i ; 
    
    printf("i = %d c = %d ",i,c);
    printf("\nAddr of i = %x ",&i);
    p = &i;
    printf("p = %x ",p);
    printf("\n value at %x = %x \n \n value at %x = %x \n value at %x = %x \n value at %x = %x ",p,*p,p+1,*(p+1),p+2,*(p+2),p+3,*(p+3));
    
    r = arr;
    printf("r = %x r+1 = %x \n",r,(r+1));
    return 0;
}

