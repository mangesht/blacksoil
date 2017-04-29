function Tree(){
    this.root = null;
    this.bfsAr = [];
    this.addNode = function (n) {
        // This adds the new Node n at appropriate position 
        // it uses functions 
        // search parent
        var p ; 
        var chld =[];
        var str = "";
        if(this.root == null) { 
            this.root = n ; 
            return ; 
        }
        p = this.search_parent(n); 
        console.log(str.concat("adding to parent = " , p.element.name , " ",n.element.name));
        chld = p.getEnclosedChildren(n);
        // We know parent , we know children , this can be inserted here 
        var i;
        var idx;
        for(i=0;i<chld.length;i++){
            idx = -1; 
            chld.parent = n ;
            idx = p.children.indexOf(chld[i]);
            if(idx >= 0) { 
                p.children.splice(idx,1);
            } else{
                console.log("Error: Invalid child ");
            }
        }
        p.addChild(n);
    }
    this.search_parent = function(n){
        var p; 
        var cur_rt = this.root;
        var found = 0; 
        while(found == 0) { 
            var idx = -1; 
            var i;
            for(i=0;i<cur_rt.children.length;i++){ 
                if(n.is_enclosed_in(cur_rt.children[i])){        
                    idx = i;
                }
            } 
            if(idx>=0){ 
                cur_rt = cur_rt.children[idx];
            }else{ 
                found = 1;
            } 
        } 
        return cur_rt; 
    }
    this.removeNode = function(n){
        // This removes the node n from tree
        var idx = -1; 
        idx = n.parent.children.indexOf(n);
        if(idx >= 0) { 
            n.parent.children.splice(idx,1);
        } else { 
            console.log("Error: Invalid removal ");
        } 
    };
    this.makeBFSArray = function (){
        this.bfsAr = [];
        this.bfsAr.push(this.root);
        var curIdx = 0 ; 
        var arLen = this.bfsAr.length;
        while(arLen > curIdx) { 
            var chld = [];
            chld = this.bfsAr[curIdx].children;
            if(chld != null){ 
                this.bfsAr = this.bfsAr.concat(chld);
            } 
            curIdx++;
            arLen = this.bfsAr.length;
        } 
    }; 
    this.show = function() { 
        var cur;
        console.log(this.root.element.name);
        cur  = this.root;
        var str = "";
        var i;
        this.makeBFSArray();
        for(i=0;i<this.bfsAr.length;i++) { 
            str = str.concat(" ",this.bfsAr[i].element.name," "); 
        } 
        console.log(str); 
    } 
} 

function Node(element){ 
    this.element = element;
    this.parent = null;
    this.children = [] ; 
    this.addChild = function(n){
        var str = "";
        n.parent = this;
        this.children.push(n);
        console.log(str.concat("added ",n.element.name , "as a child to ",this.element.name ));
        
    };
    this.getNextNode = function() {
       var idx;
       var nxt = null;
       // Lets do breath first 
       // Lets look for sibling 

       console.log("finding next node of " , this.element.name);
       if(this.parent == null) { 
           // this is Root 
           nxt = this.lookForNextGen();
           console.log("returning" , nxt.element.name);
           return nxt;
       }else{
           if(this.parent.children != null) { 
               idx = this.parent.children.indexOf(this);
               console.log("my idx is " , idx , " in children " , this.parent.children.length);
            } else { 
                console.log("returning 1");
                return null;
            } 
       } 
       if(idx  == this.parent.children.length-1){
            console.log("I am youngest in my generation");
            // You are the youngest child in your Gen
           // Check if your parent is youngest 
           // Else you can assign youe next uncle to look for next gen 
           var parIdx;
           if(this.parent.parent != null) { 
           parIdx = this.parent.parent.children.indexOf(this.parent);
           console.log("my Parent idx is " , parIdx ," in ",this.parent.children.length);

           if(parIdx == this.parent.parent.children.length-1) { 
                // parent in youngest in his generation
                // You ask your Eldest brother to look in Next Gen
                nxt = this.parent.children[0].lookForNextGen();
           } else {  
                // Choose next Uncle and ask him to look in next gen
               nxt = this.parent.parent.children[parIdx+1].lookForNextGen();
           }
           } else { 
                nxt = this.parent.children[0].lookForNextGen();
           } 
       }else{
            // Pick next sibling 
            nxt = this.parent.children[idx+1];
       }
       
       if(nxt != null) { 
           console.log("returning" , nxt.element.name);
       }else { 
           console.log("returning 3 " );
       } 
       return nxt;
    };
    this.lookForNextGen = function(){
        var nxt = null;
        var idx;
        if(this.children.length>0) { 
            nxt = this.children[0] ;
        } else {
            // Check with your Sibling
            idx = this.parent.children.indexOf(this);
            if(idx == this.parent.children.length-1){
                // This is the last in the family 
                nxt = null;
            }else{
                // Ask your next sibling to look into next gen 
                nxt = this.parent.children[idx+1].lookForNextGen();
            }
            
        }
        return nxt;
    };
    this.getEnclosedChildren= function (n){ 
        var chld = [];
        var i;
        for(i=0;i<this.children.length;i++){ 
            if(this.children[i].is_enclosed_in(n)){ 
                chld.push(this.children[i]);
            } 
        } 
        return chld;
    }; 

    this.is_enclosed_in = function (n) { 
        return (this.element.is_enclosed_in(n.element));
    } ;
}

// Test Code 
function myRect(ltx,lty,width,height) { 
    this.ltx = ltx;
    this.lty = lty; 
    this.width = width; 
    this.height = height; 
    this.style = "#000000";
    this.name = "";
    this.update_cor = function( ltx,lty,width,height) { 

         this.ltx = ltx;

         this.lty = lty; 
         this.width = width; 
         this.height = height; 
    }; 

    this.resize_shape = function (){ 
        resize_boxes = []; 
        var rz; 
        var sz = 8 ; 
        var szb2 =  sz / 2 ; 
        var str = "Resize Called. Boxes ="; 
        //var log=document.getElementById("log");
        str = str.concat( resize_boxes.length); 
        str = str.concat(this.lty ); 
        log.innerHTML = str ;

        rz = new myRect(this.ltx+this.width/2,this.lty-szb2,sz,sz); 
        resize_boxes.push(rz); 
        rz = new myRect(this.ltx+this.width-szb2,this.lty+this.height/2,sz,sz); 
        resize_boxes.push(rz); 
        rz = new myRect(this.ltx+this.width/2,this.lty+this.height-szb2,sz,sz); 
        resize_boxes.push(rz); 
        rz = new myRect(this.ltx-szb2,this.lty+this.height/2,sz,sz); 
        resize_boxes.push(rz); 
        return; 
    } ;

    this.is_enclosed_in = function (n) { 
          console.log("Checking if " , this.name , " is enclosed in " , n.name);
          if( (this.ltx  > n.ltx) && (this.lty > n.lty) && 
               ((this.ltx+this.width) < (n.ltx + n.width)) && 
               ((this.lty+this.height) < (n.lty + n.height))) { 
                console.log("True");
                return true;
           } else { 
                console.log("False");
                return false;
           }   
    } ;
} 


console.log("Mangesh here");

var t = new Tree();
var r ;
r = new myRect(0,0,1000,1000);
r.name = "test";
var n;
n  = new Node(r);
t.addNode(n);


r = new myRect(50,50,200,200);
r.name = "top";
n  = new Node(r);
t.addNode(n);

r = new myRect(350,50,200,200);
r.name = "top2";
n  = new Node(r);
t.addNode(n);

r = new myRect(51,51,50,50);
r.name = "env1";
n  = new Node(r);
t.addNode(n);


r = new myRect(351,51,50,50);
r.name = "env21";
n  = new Node(r);
t.addNode(n);

r = new myRect(102,51,50,50);
r.name = "env2";
n  = new Node(r);
t.addNode(n);


r = new myRect(402,51,50,50);
r.name = "env22";
n  = new Node(r);
t.addNode(n);

r = new myRect(103,52,20,20);
r.name = "agent1";
n  = new Node(r);
t.addNode(n);


r = new myRect(124,52,20,20);
r.name = "agent2";
n  = new Node(r);
t.addNode(n);

t.show();

