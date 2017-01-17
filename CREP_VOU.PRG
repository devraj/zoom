hide menu main
hide popup all
@ 0,1 say"Voucher Details" color r/w
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

  close all
  use &data\vouchers shared
  if sys(13)<>"READY"
   do error with "Your printer is not responding","aborting print job","Error"
   close all
   loop
  endif
  set printer on 
  set device to printer
  ??CHR(15)
  set console off
  store 48 to _norec
  store 0 to _pgtot,_total
  store 1 to _page,sno
  select a
  do while .not. eof()
   if _norec>47
    ?_head(1)+space(65-len(_head(1)))+"Date ->"+dtoc(zoom_date)
    ?_head(2)+space(65-len(_head(2)))+"Page ->"+str(_page,2)
    ?_head(3)
    ?_head(4)
    ?"--------------------------------"
    ?" "
    ?"                        << VOUCHERS FOR DATE: "+dtoc(prtdt)+" >>"
    ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
    ?" Sl | Paid to                        | On account of               | Ammount    |"
    ?" No |                                |                             |            |"
    ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
    store 0 to _norec
    store _page+1 to _page
   endif
   if vou_date=prtdt
    ?str(sno,3)+"   "+paid_to+"   "+on_act_of+" "+str(amount,10,2)
    store sno+1 to sno
    store _norec+1 to _norec
    store _pgtot+amount to _pgtot
    store _total+amount to _total
   endif
   skip
   if _norec>=47
    ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
    ?"                                                               Page:-"+str(_pgtot,10,2)
    eject
    store 0 to _pgtot
   endif
  enddo
  ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
  ?"                                                                Page:-"+str(_pgtot,10,2)
  ?"                                                         Grand Total:-"+str(_total,10,2)
  eject
  ??CHR(18)
  set printer to lpt1
  set printer off
  set device to screen
  set console on
  deacti window printer
  if dev=2
   define window view from 2,5 to 19,75 system title"Counter Sale Report" color scheme 11
   activate window view
   modi comm &_pntfile noedit window view
   deacti window view
   delete file &_prnfile
  endif
 endif
enddo
