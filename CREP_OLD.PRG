hide menu main
hide popup all
@ 0,1 say"Orders not collected for long" color r/w
set color to g+/b+,w+/bg+
define window print from 1,10 to 9,50 double shadow title" Print "
move window print center
do while .t.
 clear gets
 activate window print
 store 0 to tool
 store 1 to devi
 @ 0,2 to 6,20 color w/b
 @ 0,3 say" Output to: " color w/b
 @ 2,4 get devi function'*R Printer;Screen' size 1,10,1
 @ 2,24 get tool function'*V Print;Cancel' size 1,10,1
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
  store 31 to _lines
  store 1 to _page
  do print_job in looks
  if devi=1
   set printer to &zoom_printer
  else
  file_name=".\reports\"+sys(3)+".rep"
  set printer to &file_name
  endif
  store zoom_date-15 to _lstdt
  if sys(13)<>"READY"
   do error with "Your printer is not responding","aborting print job","Error"
   close all
   loop
  endif
  set printer on
  set device to printer
  set console off
  use &data\counter shared order ordref
  do while .not. eof()
   if _lines>30
    ?_head(1)+space(65-len(_head(1)))+"Date ->"+dtoc(zoom_date)
    ?_head(2)+space(65-len(_head(2)))+"Page ->"+str(_page,2)
    ?_head(3)
    ?_head(4)
    ?" "
    ?"                  << ORDERS NOT COLLECTED FOR MORE THAN TWO WEEKS >>"
    ?"-------------------------------------------------------------------------------------------"
    ?"Order ref| Work ord   |Wk1|Wk2|Wk3| Total      | Advance   | Cusmoter Name"
    ?"-------------------------------------------------------------------------------------------"
    store 0 to _lines
    store _page+1 to _page
   endif
   if produced=.t. .and. delivered=.f. .and. deldate<=_lstdt
    ?str(ordref,8)+" | "+str(worder,10)+" |"+str(work_code1,3)+"|"+str(work_code2,3)+"|"+str(work_code3,3)+"| "+str(amt_full,10,2)+" | "+str(advance,10,2)+"| "+cust_name
    store _lines+1 to _lines
   endif
   skip
   if _lines>30
    ?"-------------------------------------------------------------------------------------------"
    eject
   endif
  enddo
  ?"-------------------------------------------------------------------------------------------"
  eject
  set printer to lpt1
  set printer off
  set console on
  set device to screen
  deacti window printer
  close all
  set color to g+/b+,w+/bg+
  if devi=2
   deacti window all
   define window list from 2,5 to 21,75 system title" Orders not collected for long " color scheme 11
   activate window list
   modi comm &file_name noedit window list
   deacti window list
   delete file &file_name
  endif
  deactivate window printer
 endif
enddo