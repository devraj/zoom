*********************************
* Program to print Cash reports *
* Author : M. Devraj            *
*********************************
hide menu main
hide popup all
set color to g+/b+,w+/bg+
@ 0,1 say"Cash report for a date" color r/w
define window cash from 2,20 to 21,60 double shadow title" Cash Details "
move window cash center
activate window cash
qdt=zoom_date
store 0 to mny_500,mny_100,mny_50,mny_20,mny_10,mny_5,mny_2,mny_1,coins,cashtool,phy_total
store 0 to tot_500,tot_100,tot_50,tot_20,tot_10,tot_5,tot_2,tot_1
@ 14,7 say"Total : "
@ 3,14 say"X 500 ="
@ 4,14 say"X 100 ="
@ 5,14 say"X  50 ="
@ 6,14 say"X  20 ="
@ 7,14 say"X  10 ="
@ 8,14 say"X   5 ="
@ 9,14 say"X   2 ="
@ 10,14 say"X   1 ="
@ 1,7 say"Date : "get qdt pict'99/99/99'
@ 3,7 get mny_500 pict'999999'
@ 4,7 get mny_100 pict'999999'
@ 5,7 get mny_50 pict'999999'
@ 6,7 get mny_20 pict'999999'
@ 7,7 get mny_10 pict'999999'
@ 8,7 get mny_5 pict'999999'
@ 9,7 get mny_2 pict'999999'
@ 10,7 get mny_1 pict'999999'
@ 12,7 say"Money in coins : "get coins pict'9999.99'
@ 16,2 get cashtool function'*H Print;View;Cancel' size 1,10,2 when calculate()
read cycle

if cashtool=3 .or. cashtool=0
 deacti window all
 close all
 do ctop in looks
 return to menu
endif

if cashtool=1 .or. cashtool=2
 deactivate window all
 do clock in looks
 store 0 to AR,AM, ACR, ACRD
 use &data\counter shared
 Sum Advance To AR for ORDDT=Qdt
 sum amt_Recd to am for delon=qdt

 use &data\credit shared
 SUM amt_paid To ACR for date=Qdt
 
 use &data\sales shared
 sum total_amt to sales_money for sale_date=qdt
 
 use &data\vouchers shared
 sum amount to less for vou_date=qdt
 count for vou_date=qdt to nov
 
 use &data\lam_ord shared
 sum advance to _ladv for book_date=qdt
 sum due to _ldue for del_date=qdt
 lam_money=_ladv+_ldue
 
 use
 
 total=ar+am+less+sales_money+lam_money
 
 ********** store data
 use &data\cashrep shared order date
 seek qdt
 if found()
  if _admin=.t.
   do error with "The cash report for this date was generated","cannot duplicate it, contact Administrator","Secure data"
  else
   replace advance with ar
   replace delivery with am
   replace expenses with less
   replace voucher with nov
   replace sales with sales_money
   replace lami with lam_money
   replace credit with acr
   replace money_500 with mny_500
   replace money_100 with mny_100
   replace money_50 with mny_50
   replace money_20 with mny_20
   replace money_10 with mny_10
   replace money_05 with mny_5
   replace money_02 with mny_2
   replace money_01 with mny_1
   replace money_coins with coins
  endif
 else
  append blank
  replace advance with ar
  replace delivery with am
  replace expenses with less
  replace voucher with nov
  replace sales with sales_money
  replace credit with acr
  replace money_500 with mny_500
  replace money_100 with mny_100
  replace money_50 with mny_50
  replace money_20 with mny_20
  replace money_10 with mny_10
  replace money_05 with mny_5
  replace money_02 with mny_2
  replace money_01 with mny_1
  replace money_coins with coins
  replace date with qdt
 endif
 close all
 ********** end store
 deacti window clock
 if cashtool=2
  printfile=".\reports\"+sys(3)+".rep"
  set printer to &printfile
 endif
 if sys(13)<>"READY"
  do error with "Your printer is not responding","aborting print job","Error"
  close all
  do ctop in looks
  retu .t.
 endif
 set printer on
 set device to printer
 set console off
 ?"ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
 ?"³"+space((41-len(_head(1)))/2)+_head(1)+space(39-len(space((41-len(_head(1)))/2)+_head(1)))+"³"
 ?"³"+space((41-len(_head(2)))/2)+_head(2)+space(39-len(space((41-len(_head(2)))/2)+_head(2)))+"³"
 ?"³"+space((41-len(_head(3)))/2)+_head(3)+space(39-len(space((41-len(_head(3)))/2)+_head(3)))+"³"
 ?"³"+space((41-len(_head(4)))/2)+_head(4)+space(39-len(space((41-len(_head(4)))/2)+_head(4)))+"³"
 ?"ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
 ?" "
 ?? chr(27)+chr(69)
 ?"                     Date : "+dtoc(qdt)
 ?? chr(27)+chr(70)
 ?" "
 ?" Advance received     : Rs. "+str(ar,10,2)
 ?" Delivery reciept     : Rs. "+str(am,10,2)
 ?? chr(27)+chr(69)
 ?" Total reciept        : Rs. "+str(ar+am,10,2)
 ?? chr(27)+chr(70)
 ?" "
 ?" Expenses             : Rs. "+str(less,10,2)
 ?" (Number of vouchers "+ltrim(str(nov))+")"
 ?" "
 ?" Counter Sales        : Rs. "+str(sales_money,10,2)
 ?" Lamination           : Rs. "+str(lam_money,10,2)
 ?" "
 ?? chr(27)+chr(69)
 ?" Total cash collected : Rs. "+str(total,10,2)
 ?? chr(27)+chr(70)
 if phy_total<total
  ?" Shortage             : Rs. "+str(total-phy_total,10,2)
  netamt=total-(total-phy_total)
 endif
 if phy_total>total
  ?" Excess               : Rs. "+str(phy_total-total,10,2)
  netamt=total+(phy_total-total)
 endif
 ?? chr(27)+chr(69)
q ?" Net Cash Collected   : Rs. "+str(netamt,10,2)
 ?" "
 ?"                CASH DETAILS"
 ?? chr(27)+chr(70)
 ?"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
 ?" "
 ?" "+str(mny_500,6)+" X 500 = "+str(tot_500,10,2)
 ?" "+str(mny_100,6)+" X 100 = "+str(tot_100,10,2)
 ?" "+str(mny_50,6)+" X  50 = "+str(tot_50,10,2)
 ?" "+str(mny_20,6)+" X  20 = "+str(tot_20,10,2)
 ?" "+str(mny_10,6)+" X  10 = "+str(tot_10,10,2)
 ?" "+str(mny_5,6)+" X   5 = "+str(tot_5,10,2)
 ?" "+str(mny_2,6)+" X   2 = "+str(tot_2,10,2)
 ?" "+str(mny_1,6)+" X   1 = "+str(tot_1,10,2)
 ?"        Coins = "+str(coins,10,2)
 ?" "
 ?? chr(27)+chr(69)
 ?"        Total = "+str(phy_total,10,2)
 ?? chr(27)+chr(70)
 ?" "
 ?" "
 ?"                            (Sales man)"
 ?"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
 ??CHR(13)
 set printer to lpt1
 set printer off
 set console on
 set device to screen
 if cashtool=2 
  define window view from 2,2 to 18,67 system shadow title" View Report - Cash reports " color scheme 11
  move window view center
  activate window view
  modi comm &printfile noedit window view
  deacti window view
  delete file &printfile
 endif
 deactivate window all
 do ctop in looks
 close all
 return to menu 
endif


proc calculate
tot_500=mny_500*500
@ 3,21 say tot_500
tot_100=mny_100*100
@ 4,21 say tot_100
tot_50=mny_50*50
@ 5,21 say tot_50
tot_20=mny_20*20
@ 6,21 say tot_20
tot_10=mny_10*10
@ 7,21 say tot_10
tot_5=mny_5*5
@ 8,21 say tot_5
tot_2=mny_2*2
@ 9,21 say tot_2
tot_1=mny_1*1
@ 10,21 say tot_1
phy_total=tot_500+tot_100+tot_50+tot_20+tot_10+tot_5+tot_2+tot_1+coins
@ 14,7 say"Total : "+str(phy_total,10,2)
return .t.