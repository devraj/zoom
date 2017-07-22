hide menu main
hide popup all
@ 0,1 say"Remove agent order" color r/w
set color to g+/b+,w+/bg+
define window agrem from 1,0 to 9,60 double shadow title" Remove "
move window agrem center
do while .t.
 activate window agrem
 @ 0,2 to 5,30 color w/b
 @ 0,32 to 5,56 color w/b
 @ 0,3 say" Order Reference " color w/b
 @ 0,33 say" Work Order " color w/b
 store 0 to word,agn,ord,tool
 @ 2,4 say"Agent Code     :"get agn pict'9999'
 @ 3,4 say"Order Reference:"get ord size 1,8,10
 @ 3,34 say"Work Order:"get word pict'99999999'
 @ 6,17 get tool function'*H Find;Cancel' size 1,10,4
 read cycle
 if tool=0 .or. tool=2
  clear window all
  close all
  do ctop in looks
  return .t.
  exit
 endif
 ***********
 if tool=1 
  use &data\agnfile shared
  if ord>0
   set order to ordref
   locate for agent_code=agn .and. order_num=ord
  else
   set order to worder
   seek word
  endif
  if found()
   store 0 to confirm
   do confirm in looks
   if confirm=1
    delete
   endif
   close all
  else
   close all
   do error with "The requested order was not found","","Sorry"
  endif
 endif
enddo