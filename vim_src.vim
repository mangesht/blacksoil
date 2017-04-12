" :runtime macros/matchit.vim
:se nu
:se hlsearch
:set ts=4
:set expandtab
set guifont=Courier\ 10\ Pitch\ 14
"set guifont=Droid\ Sans\ Mono\ 12

" Expansions for UVM

:iab info  `uvm_info(get_name(),$sformat(""),UVM_NONE);<ESC>bbblli 
:iab error `uvm_error(get_name(),$sformat(""));<ESC>blli 
:iab iff if( ) begin <ESC>o end else begin<ESC>o end<ESC>


"if exists("loaded_matchit")
"    echo "Matchit exists"
"else 
"    echo "Matchit does not exist"
"endif
