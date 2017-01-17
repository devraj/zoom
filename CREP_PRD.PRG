hide menu main
hide popup all
@ 0,1 say"Order production for a date" color r/w
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
 store 1 to devi
 @ 2,3 say"Print report for date :"get prtdt pict'99/99/9999'
 @ 6,6 get devi function'*VR Printer;Screen' size 1,15,2
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
  store 31 to _lines
  store 1 to _page
  do print_job in looks
  if devi=1
   set printer to &zoom_printer
  else
   file_name=".\reports\"+sys(3)+".rep"
   set printer to &file_name
  endif
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
    ?"                        << ORDERS PRODUCTION ON "+DTOC(PRTDT)+" >>"
    ?"-------------------------------------------------------------------------------------------"
    ?"Order ref| Work ord   |Wk1|Qty1|Wk2|Qty2|Wk3|Qty3| Total      | Advance   | Due"
    ?"-------------------------------------------------------------------------------------------"
    store 0 to _lines
    store _page+1 to _page
   endif
   if produced=.t. .and. prod_date=prtdt
    ?str(ordref,8)+" | "+str(worder,10)+" |"+str(work_code1,3)+"|"+str(work_qty1,4)+"|"+str(work_code2,3)+"|"+str(work_qty2,4)+"|"+str(work_code3,3)+"|"+str(work_qty3,4)+"| "+str(amt_full,10,2)+" | "+str(advance,10,2)+" | "+str(amt_due,10,2)
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
   define window list from 2,5 to 21,75 system title" Orders produced on a date " color scheme 11
   activate window list
   modi comm &file_name noedit window list
   deacti window list
   delete file &file_name
  endif
  deactivate window printer
 endif
enddo