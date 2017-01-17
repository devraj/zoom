*Counter sales

hide menu main
hide popup all
@ 0,1 say"Counter Sales" color r/w
set color to g+/b+,w+/bg+
define window sales from 1,10 to 20,70 double shadow title" Sales "
move window sales center
activate window sales
do while .t.
 clear
 do lng_mess with "Creating a list of sale items","from data sources","Wait" in looks
 use &data\stk_itm shared
 set order to name
 count for counter=.t. to _cntrecs
 if _cntrecs=0
  close all
  deacti window all
  do ctop in looks
  do error with "This option is currently invalid","no items available","Error"
  return .t.
  exit
 endif
 dimen _items(_cntrecs,4)
 go top
 store 1 to _tmpcount
 do while .not. eof()
  if counter=.t.
   store item_name to _items(_tmpcount,1)
   store balance to _items(_tmpcount,2)
   store item_code to _items(_tmpcount,3)
   store unit_price to _items(_tmpcount,4)
   _tmpcount=_tmpcount+1
  endif
  skip
 enddo
 close all
 deacti window lng_mes
 activate window sales
 set color to g+/b+,w+/bg+
 @ 2,2 say"Counter sale item :"
 store 0 to ch_item, qty, tax, dis_typ, dis_per,mem_no,total,tool
 store space(20) to rem
 store zoom_date to dt_pur
 store 1 to qty, ch_item
 set cursor on
 @ 1,22 get ch_item from _items size 3,30 color scheme 11
 @ 5,2 say "Date : "get dt_pur pict'99/99/9999' when balance()
 @ 5,22 say"Balance :"
 @ 5,39 say"Quantity : "get qty pict'9999' valid balcheck(qty,_items(ch_item,2))
 @ 7,2 say"Unit Price :"
 @ 7,26 say"Tax" get tax pict'99.99'
 @ 7,37 say"%"
 @ 9,2 to 14,56 color w/b
 @ 10,4 get dis_typ function'*VR DISCOUNT;KEX MEMBER' size 1,15,1 valid disdet(dis_typ)
 @ 10,25 get dis_per pict'99.99' disabled 
 @ 10,32 say"%"
 @ 12,25 say"Membership No :"get mem_no pict'999999' disabled valid kexmem(mem_no)
 @ 15,2 say"REMARKS :"get rem pict'@!' size 1,20 when total()
 @ 15,33 say "Total : Rs."
 @ 17,3 get tool function'*H Save & Print;Save;Cancel' size 1,15,4
 read cycle
 if tool=3 .or. tool=0
  clear window all
  close all
  do ctop in looks
  return .t.
  exit
 endif
 if tool=1 .or. tool=2
  if qty<=0
   do error with "Invalid quantity being sold","","Error"
   loop
  endif
  do total
  use &data\sales shared
  append blank
  _tmrec=recno()
  replace item_code with _items(ch_item,3)
  replace quantity with qty
  replace sale_date with dt_pur
  replace unit_price with _items(ch_item,4)
  replace tax_per with tax
  replace disc_per with dis_per
  if dis_typ=2
   replace kex_member with .t.
   replace mem_num with mem_no
  else
   replace kex_member with .f.
  endif
  replace remarks with rem
  replace total_amt with total
  
  use &data\stk_itm shared
  set order to code
  seek _items(ch_item,3)
  if found()
   replace balance with balance-qty
   _tmpbal=balance
  else
   do error with "Could not update stock entry","","Error"
  endif
  
  use &data\stk_trns shared
  append blank
  replace item_code with _items(ch_item,3)
  replace outgoing with qty
  replace balance with _tmpbal
  replace date with dt_pur
  replace describe with "COUNTER SALES"
  use
  if tool=1
   do pntbill with _tmrec
  endif  
 endif
enddo




proc balance
@ 5,33 say _items(ch_item,2) pict'9999' color w+/b
@ 7,14 say _items(ch_item,4) pict'9999999.99' color w+/b
return .t.

proc disdet
parameter _tmpcode
if _tmpcode=1
 show get dis_per enabled
 show get mem_no disabled
endif
if _tmpcode=2
 show get dis_per disabled
 show get mem_no enabled
endif
return .t.

proc kexmem
parameter _tmpmemno
use &data\kexmem
set order to mem_no
seek _tmpmemno
if found()
 @ 13,25 say "NAME :"+rtrim(mem_name) color w+/b+
 if doi>=zoom_date .and. doe<=zoom_date
  use
  do error with "This KEX membership has expired","","Error"
  dis_typ=0
  show get dis_typ enabled
  return .t.
 endif
 use
 return .t.
else
 define popup _tmp from 8,30 to 17,66 shadow title" Select member " prompt field str(mem_no,4)+" "+mem_name color scheme 11
 on selection popup _tmp deacti popup _tmp
 activate popup _tmp
 @ 13,25 say "NAME :"+rtrim(mem_name) color w+/b+
 store mem_no to _tmpmem
 use
 mem_no=_tmpmem
 show get mem_no
 return .t.
endif

proc total
_tmptotal=qty*_items(ch_item,4)
store 0 to lessamt
if dis_typ=1
 lessamt=(dis_per/100)*_tmptotal
endif
if dis_typ=2
 use &data\system shared
 dis_per=kex_dis
 use
 lessamt=(dis_per/100)*_tmptotal
endif
total=_tmptotal-lessamt
@ 15,45 say total pict'9999999.99'
return .t.

proc balcheck
parameter qt1,qt2
if qt1>qt2
 do error with "Quantity incresing current balance","","Error"
 return .f.
else
 return .t.
endif

**************** bill printing procedure
proc pntbill
para _recbill
if sys(13)="OFFLINE"
 do error with "YOUR PRINTER IS NOT RESPONDING","","Print error"
 return .t.
endif
close all
use &data\sales shared
goto _recbill
set printer to &zoom_printer
set printer on
set device to printer 
set console off
store item_code to _itcd
use &data\stk_itm shared order code
seek _itcd
if found()
 store item_name to _itnm
else
 store "N/A"+space(27) to _itnm
endif
use &data\sales shared
goto _recbill
store total_amt to tot
store quantity to qty
store tax_per to _tp
store (tax_per/100)*unit_price to tax_amt
store unit_price-tax_amt to up_lt
store unit_price*quantity to act_amt
store total_amt to _rtamt
store "-----------------------------------------------------------------" to _lbreak
??CHR(15)
?space((len(_lbreak)-len(_head(1)))/2)+_head(1)
?space((len(_lbreak)-len(_head(2)))/2)+_head(2)
?space((len(_lbreak)-len(_head(3)))/2)+_head(3)
?space((len(_lbreak)-len(_head(4)))/2)+_head(4)
?" "
?space((len(_lbreak)-len("BILL / RECIEPT OF COUNTER SALE"))/2)+"BILL / RECIEPT OF COUNTER SALE"
?_lbreak
?" Item                          | Unit Price | Qty  | Total      |"
?_lbreak
?" "+_itnm+" | "+str(up_lt,10,2)+" | "+str(qty,4)+" | "+str(up_lt*qty,10,2)+" |"
?" "
?"                                   + Tax @ "+str(_tp,5,2)+"% = "+str(tax_amt*qty,10,2)
if kex_member=.t.
 ?"                   - KEX Member discount @ "+str(disc_per,5,2)+"% = "+str(((disc_per/100)*tot),10,2)
endif
if disc_per>0 .and. kex_member=.f.
 ?"                              - Discount @ "+str(disc_per,5,2)+"% = "+str(((disc_per/100)*tot),10,2)
endif
?_lbreak
?"                                Total amt. Rs."+str(_rtamt,10,2)
?" "
?" "
?" "
?"                                                     (Signature)"
?" "
??CHR(18)
close all
set printer off
set console on
set device to screen
return .t.
