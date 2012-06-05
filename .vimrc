se nu
set expandtab
set ts=4
set autoindent
set hlsearch
if has("gui_running")
  echo "Gui running"
   if has("gui_gtk2")
     set guifont=Courier\ New\ 11
    echo "gtk2"
   elseif has("gui_photon")
     set guifont=Courier\ New:s11
    echo "gui_photon"
  elseif has("gui_kde")
     set guifont=Courier\ New/11/-1/5/50/0/0/0/1/0
  elseif has("x11")
    echo "gui_x11"
    set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
    "# On Solaris machine you can see font name Font desciption window
    "# You get this when you type :set guifont=* 
    "# The second tab is gui font description where font name is displayed
  else
    echo "default"
     set guifont=Courier_New:h12:cDEFAULT
   endif
else 
  echo "Gui Not running"
endif
