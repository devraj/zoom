hide menu main
hide popup all
@ 0,1 say"Daily Job work summary" color r/w
set color to g+/b+,w+/bg+
define window print from 1,10 to 14,70 double shadow title" Reports "
move window print center
do while .t.
 clear gets
 set color to g+/b+,w+/bg+
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
 **************** start print job
 if tool=1
  use &data\counter shared order delon
  seek prtdt
  if .not. found()
   close all
   do error with "No data for this date found","cannot generate a report","Error"
   loop
  endif
  
  deacti window print
  do print_job in looks
  if dev=1
   set printer to &zoom_printer
  else
   _pntfile=".\reports\"+sys(3)+".rep"
   set printer to &_pntfile
  endif
  
  select a
   use &data\paytype shared
   
  select b
   use &data\counter shared order worder
  
  select c
   use &data\cardet shared
  
  if sys(13)<>"READY"
   do error with "Your printer is not responding","aborting print job","Error"
   loop
  endif
  set printer on
  set console off
  set device to printer
   
  select a
  store reccount() to _tprec
  go top
  store 0 to _gfull,_gadv,_gdue,_grecd,_gref, _gtax, _pgscamt, _gscamt
  store 48 to _norec
  store 1 to _page
  select a
  do while .not. eof()
   store pay_code to _paycd
   store pay_name to _paynm
   store creditcard to _cc
   select b
   set order to delon
   store 0 to _nrec
   count for delon=prtdt .and. pay_code=_paycd to _nrec
   store 48 to _norec
   if _nrec<>0
    set order to worder
    go top
    store 0 to _pgfull,_pgadv,_pgdue,_pgrecd,_pgref, _pgscamt
    do while .not. eof()
     if _norec>47
      ?_head(1)+space(65-len(_head(1)))+"Date       ->"+dtoc(zoom_date)
      ?_head(2)+space(65-len(_head(2)))+"Page       ->"+str(_page,2)
      ?_head(3)+space(65-len(_head(3)))+"Payment by ->"+rtrim(_paynm)
      ?_head(4)
      ?" "
      ?"                        << DAILY JOB WORK SUMMARY ON "+dtoc(prtdt)+" >>"
      ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
      ?"Work    |Order  |Wk|Qty1|Wk|Qty2|Wk|Qty3|Full     | Service |      Tax |Less      |Amount    |"
      ?"Order   |Refn.  |1 |    |2 |    |3 |    |Amount   |  Charge |   Amount |Advance   |Received  |"
      ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
      store 0 to _norec
      store _page+1 to _page
      store 0 to _pgfull,_pgadv,_pgdue,_pgrecd,_pgref, _pgtax, _pgscamt
     endif
	 if amt_recd<0 
	 	_rem=' Rfd.'
	 else
	 	_rem = ''
	 endif
	 if discount 
	 	_rem2='*'
	 else
	 	_rem2 = ''
	 endif
	  if delon=prtdt .and. pay_code=_paycd
*     if amt_recd>=0 .and. delon=prtdt .and. pay_code=_paycd
*     ?str(worder,8)+" "+str(ordref,7)+" "+str(work_code1,2)+" "+str(work_qty1,4)+" "+str(work_code2,2)+str(work_qty2,4)+" "+str(work_code3,2)+str(work_qty3,4)+" "+str(amt_full,10,2)+" "+str(advance,10,2)+" "+str(amt_due,10,2)+" "+str(amt_recd,10,2)
*      ?str(worder,8)+" "+str(ordref,7)+" "+str(work_code1,2)+" "+str(work_qty1,4)+" "+str(work_code2,2)+str(work_qty2,4)+" "+str(work_code3,2)+str(work_qty3,4)+" "+str(ntotal,10,2)+" "+str(tax_amt,10,2)+" "+str(advance,10,2)+" "+str(amt_recd,10,2)+_rem
**** 10-10-2004
	 scamt=amt_full-icamt
*      ?str(worder,8)+" "+str(ordref,7)+" "+str(work_code1,2)+" "+str(work_qty1,4)+" "+str(work_code2,2)+str(work_qty2,4)+" "+str(work_code3,2)+str(work_qty3,4)+" "+str(amt_full,10,2)+" "+str(tax_amt,10,2)+" "+str(advance,10,2)+" "+str(amt_recd,10,2)+_rem+_rem2
      ?str(worder,8)+" "+str(ordref,7)+" "+str(work_code1,2)+" "+str(work_qty1,4)+" "+str(work_code2,2)+str(work_qty2,4)+" "+str(work_code3,2)+str(work_qty3,4)+" "+str(amt_full,10,2)+" "+str(scamt,10,2)+" "+str(tax_amt,10,2)+" "+str(advance,10,2)+" "+str(amt_recd,10,2)+_rem+_rem2
****
      store _norec+1 to _norec
      ********************* store page totals
      store _pgfull+amt_full to _pgfull
*      store _pgfull+ntotal to _pgfull
      store _pgscamt+scamt to _pgscamt
      store _pgtax+tax_amt to _pgtax
      store _pgadv+advance to _pgadv
      store _pgdue+amt_due to _pgdue
      store _pgrecd+amt_recd to _pgrecd
	  if amt_recd<0
      store _pgref+abs(amt_recd) to _pgref
      store _gref+abs(amt_recd) to _gref
	  endif
      ******************** store grand totals
      store _gfull+amt_full to _gfull
      store _gscamt+scamt to _gscamt
*      store _gfull+ntotal to _gfull
      store _gtax+tax_amt to _gtax
      store _gadv+advance to _gadv
      store _gdue+amt_due to _gdue
      store _grecd+amt_recd to _grecd
      ********************* end store
     endif
     skip
     if _norec>47
      ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
      ?"                     Page Totals :     "+str(_pgfull,10,2)+" "+str(_pgscamt,10,2)+" "+str(_pgtax,10,2)+" "+str(_pgadv,10,2)+" "+str(_pgrecd,10,2)
      eject
     endif
    enddo
    ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
    ?"                     Page Totals :     "+str(_pgfull,10,2)+" "+str(_pgscamt,10,2)+" "+str(_pgtax,10,2)+" "+str(_pgadv,10,2)+" "+str(_pgrecd,10,2)
    ************** print credit card details
    if _cc=.t.
     ?" "
     ?" "
     ?" CREDIT CARD DETAILS FOR "+_paynm
     ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
     ?" Order    | Holder Name                    | Card number         | Valid upto |"
     ?" Reference|                                |                     |            |"
     ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
     select c
     do while .not. eof()
      if _norec>47
       ?" CREDIT CARD DETAILS FOR "+rtrim(_paynm)+" (contd...)"
       ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
       ?" Order    | Holder Name                    | Card number         | Valid upto |"
       ?" Reference|                                |                     |            |"
       ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
       store 0 to _norec
      endif
      select c
      if order_date=prtdt .and. pay_code=_paycd
       ?str(order_no,9)+" | "+holder_nm+" | "+card_no+" | "+dtoc(valid_dt)
       _norec=_norec+1
      endif
      skip
      if _norec>47
       eject
      endif
     enddo
     ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
     ************ end credit card details
    endif    
    select a
    skip
    if recno()<_tprec
     eject
    endif
   else
    select a
    skip
   endif
   **************** end print details
  enddo
  select b
  go top
  sum advance for orddt=prtdt to xadv 
*  if (_grecd-_gref)<>(_gfull-_gadv)
  if (_grecd)<>(_gfull-_gadv)
   xdif=" & Diff. is "+str((_gfull+_gtax-_gadv)-_grecd,10,2)
  else
   xdif=space(1)
  endif
  for devraj=1 to 4
   ?" "
  endfor
  ?"                    Grand Totals :     "+str(_gfull,10,2)+" "+str(_gtax,10,2)+" "+str(_gadv,10,2)+" "+str(_grecd,10,2)
*  ?"                    Grand Totals :     "+str(_gfull,10,2)+" "+str(_gadv,10,2)+" "+str(_gdue,10,2)+" "+str(_grecd,10,2)
  ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
  ? '     (a) Amount to be received (Bill-L.Adv)        : '+str((_gfull+_GTAX-_gadv),10,2)
  ? '     (b) Actual amount received (Receipt - Refund) : '+str((_grecd-_gref),10,2)+' '+xdif
  ? '     (c) Total Adv. Recevied for Today             : '+str(xadv,10,2)
  ? '     (d) Total Service Tax                         : '+str(_gtax,10,2)
  ? '     (e) Amount refunded                           : '+str(_gref,10,2)
  ? '     TOTAL ACTUAL CASH RECEIPT   (b + c)           : '+str((_grecd-_gref+xadv),10,2)
  ?"컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴"
  eject
  deacti window printer
  set printer to lpt1
  set printer off
  set device to screen
  set console on
  deacti window printer
  set color to g+/b+,w+/bg+
  close all
  if dev=2
   deacti window all
   define window list from 2,5 to 21,75 system title" Counter reports " color scheme 11
   activate window list
   modi comm &_pntfile noedit window list
   deacti window list
   delete file &_pntfile
  endif
  close all
 endif
enddo