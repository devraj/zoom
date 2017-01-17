hide menu main
hide popup all
@ 0,1 say"Counter Activity Report" color r/w
set color to g+/b+,w+/bg+
define window print from 1,10 to 14,70 double shadow title" Reports "
move window print center
do while .t.
 clear gets
 activate window print
 @ 1,1 to 3,62 color w/b
 @ 4,1 to 11,30 color w/b
 @ 1,2 say" Report Parameters " color w/b
 @ 4,2 say" Print Device " color w/b
 store zoom_date to prtdt
 store 0 to tool
 store 1 to dev
 @ 2,3 say"Print report for date :"get prtdt pict'99/99/9999'
 @ 6,6 get dev function'*VR Printer;Screen' size 1,15,2
 @ 6,37 get tool function'*V Print;Cancel' size 1,15,2
 read cycle
 if tool=0 .or. tool=2
  close all
  clear window all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1
  deacti window print
  do print_job in looks
  if dev=1
   set printer to &zoom_printer
  else
   _pntfile=".\reports\"+sys(3)+".rep"
   set printer to &_pntfile
  endif
  use &data\counter shared order worder
  count for orddt=prtdt to cntr
  if cntr=0
   close all
   do error with "No data for this date found","cannot generate a report","Error"
   loop
  endif
  go top
  if sys(13)<>"READY"
   do error with "Your printer is not responding","aborting print job","Error"
   loop
  endif
  set printer on 
  set device to printer
  set console off
  store 48 to _norec
  store 1 to _page
  do while .not. eof()
   if _norec>47
    ?_head(1)+space(75-len(_head(1)))+"Date ->"+dtoc(zoom_date)
    ?_head(2)+space(75-len(_head(2)))+"Page ->"+str(_page,2)
    ?_head(3)
    ?_head(4)
    ?" "
    ?"                        << Counter Activity = Orders booked on "+dtoc(prtdt)+" >>"
    ?"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    ?" Work     |Order    |Wk|Wk|Wk|          |Delivery  | Customer Name"
    ?" Order    |Refn.    |1 |2 |3 |Advance   |Date      |"
    ?"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    store 0 to _norec
    store _page+1 to _page
   endif
   if orddt=prtdt
    ?"  "+str(worder,8)+"   "+str(ordref,7)+" "+str(work_code1,2)+" "+str(work_code2,2)+" "+str(work_code3,2)+" "+str(advance,10,2)+" "+dtoc(deldate)+"   "+cust_name
    store _norec+1 to _norec
   endif
   skip
   if _norec>47
    ?"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
    eject
   endif
  enddo
  ?"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
  eject
  set printer to lpt1
  set printer off
  set device to screen
  set console on
  deacti window printer
  if dev=2
   define window view from 2,5 to 19,75 system title"Counter Activity Report" color scheme 11
   activate window view
   modi comm &_pntfile noedit window view
   deacti window view
   delete file &_prnfile
  endif
 endif
enddo
