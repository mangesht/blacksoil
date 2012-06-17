
 class parent;

    virtual task walk(integer i);
    task run();
endclass 

task parent::walk(integer i);
    printf("Parent walking %d \n",i);
endtask

task parent::run();
    //walk(i);
    printf("Parent running \n");
endtask

class child extends parent;
    integer i ;
    virtual task walk(integer i);
    task run();
    endclass

task child::walk(integer i)begin 
    printf("Child cannot walk %d\n",i);
endtask

task child::run()begin 
     printf("Child cannot run\n");
endtask

class grand_child extends child ;
    integer  shekhar ;
    task walk(integer i);
    task run ();
    endclass
task grand_child::walk(integer i);
    printf("Grand Child cannot walk . Expectation is too much \n");
endtask
task grand_child::run();
    printf("Grand Child cannot run \n");
endtask
program first()
    child c ;
    parent p ;
    grand_child g;
    c = new ;
    p = new ;
    g = new ;
   printf("Parent Walk \n");
    p.walk();
    p = g ; 
    //printf( " Shekhar = %d \n",p.shekhar  ); // Not an allowed operation 
 
    //g.walk();
    printf ("Pure child \n");
    c.walk(2);
    c.run();
    p = c ; 
    printf ("parent pointer child object \n");
    p.walk(3);
    p.run();    // p.run(3);
    p = g; 
    printf("Parent Pointer Grand Child object \n");
    p.walk(3);
    p.run();
    c = g ; 
    // g = c ; // This is illegal assignment 
    cast_assign(g,c);
    printf("Child pointer Grand Child Object \n");
    c.walk(3);
    c.run();
    
endprogram 
//  ++---------------------------------------------------------------------++
//  ||                     VERA System Verifier (TM)                       ||
//  ||        Version: X-2005.12 () -- Mon Aug  2 04:13:29 2010            ||
//  ||             Copyright (c) 1995-2004 by Synopsys, Inc.               || 
//  ||                      All Rights Reserved                            ||
//  ||                                                                     ||
//  ||      For support, send email to vera-support@synopsys.com           ||
//  ||                                                                     ||
//  ||  This software and the associated documentation are confidential    ||
//  ||  and proprietary to Synopsys Inc.  Your use or disclosure of this   ||
//  ||  software is subject to the terms and conditions of a written       ||
//  ||  license agreement between you, or your company, and Synopsys, Inc. ||
//  ++---------------------------------------------------------------------++ 
// Pure child 
// Child cannot walk           2
// Child cannot run
// parent pointer child object 
// Child cannot walk           3
// Parent running 
// Parent Pointer Grand Child object 
// Grand Child cannot walk . Expectation is too much 
// Parent running 
// Child pointer Grand Child Object 
// Grand Child cannot walk . Expectation is too much 
// Child cannot run
// Vera: finish encountered at cycle       0
// 	total       mismatch: 0
// 	           vca_error: 0
// 	      fail(expected): 0
// 	               drive: 0
// 	              expect: 0
// 	              sample: 0
// 	                sync: 0
